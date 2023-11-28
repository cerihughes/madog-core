//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public final class Madog<T>: ContainerUIDelegate {
    private let registrar = Registrar<T>()
    private let contentFactory: ContainerUIContentFactoryImplementation<T>
    private let containerRepository: ContainerUIRepository<T>

    public internal(set) var currentContainer: AnyContainer<T>?

    public init() {
        contentFactory = .init(registry: registrar.registry)
        containerRepository = .init(registry: registrar.registry, contentFactory: contentFactory)
        contentFactory.delegate = self
    }

    public func resolve(resolver: AnyResolver<T>, launchOptions: LaunchOptions? = nil) {
        registrar.resolve(resolver: resolver, launchOptions: launchOptions)
    }

    @discardableResult
    public func addContainerUIFactory<VC>(
        identifier: ContainerUI<T, SingleUITokenData<T>, VC>.Identifier,
        factory: AnyContainerUIFactory<T, SingleUITokenData<T>, VC>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerUIFactory(identifier: identifier.value, factory: factory.wrapped())
    }

    @discardableResult
    public func addContainerUIFactory<VC>(
        identifier: ContainerUI<T, MultiUITokenData<T>, VC>.Identifier,
        factory: AnyContainerUIFactory<T, MultiUITokenData<T>, VC>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerUIFactory(identifier: identifier.value, factory: factory.wrapped())
    }

    @discardableResult
    public func addContainerUIFactory<VC>(
        identifier: ContainerUI<T, SplitSingleUITokenData<T>, VC>.Identifier,
        factory: AnyContainerUIFactory<T, SplitSingleUITokenData<T>, VC>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerUIFactory(identifier: identifier.value, factory: factory.wrapped())
    }

    @discardableResult
    public func addContainerUIFactory<VC>(
        identifier: ContainerUI<T, SplitMultiUITokenData<T>, VC>.Identifier,
        factory: AnyContainerUIFactory<T, SplitMultiUITokenData<T>, VC>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerUIFactory(identifier: identifier.value, factory: factory.wrapped())
    }

    @discardableResult
    public func renderUI<VC, TD>(
        identifier: ContainerUI<T, TD, VC>.Identifier,
        tokenData: TD,
        in window: Window,
        transition: Transition? = nil,
        customisation: CustomisationBlock<VC>? = nil
    ) throws -> AnyContainer<T> where VC: ViewController, TD: TokenData {
        let container = try createContainer(
            identifiableToken: .init(identifier: identifier, data: tokenData),
            parent: nil,
            customisation: customisation
        )
        window.setRootViewController(container.containerViewController, transition: transition)
        return container.proxy()
    }

    public var serviceProviders: [String: ServiceProvider] {
        registrar.serviceProviders
    }

    // MARK: - ContainerUIDelegate

    func createContainer<VC, TD>(
        identifiableToken: IdentifiableToken<T, TD, VC>,
        parent: AnyInternalContainer<T>?,
        customisation: CustomisationBlock<VC>?
    ) throws -> ContainerUI<T, TD, VC> where VC: ViewController, TD: TokenData {
        let container = try containerRepository.createContainer(identifiableToken: identifiableToken)
        let containerViewController = container.containerViewController
        container.delegate = self
        persist(container: container, parent: parent)
        customisation?(containerViewController)

        return container
    }

    func releaseContainer(_ container: AnyContainer<T>) {
        if container.uuid == currentContainer?.uuid {
            currentContainer = nil
        }
    }

    // MARK: - Private
    private func persist<VC, TD>(container: ContainerUI<T, VC, TD>, parent: AnyInternalContainer<T>?) {
        container.parentInternalContainer = parent
        parent?.childContainers.append(container)

        if parent == nil {
            currentContainer = container
        }
    }
}

#if canImport(UIKit)

extension Window {
    func setRootViewController(_ viewController: ViewController, transition: Transition?) {
        rootViewController = viewController

        if let transition {
            View.transition(with: self, duration: transition.duration, options: transition.options, animations: {})
        }
    }
}

#elseif canImport(AppKit)

extension Window {
    func setRootViewController(_ viewController: ViewController, transition: Transition?) {
        contentViewController = viewController
    }
}

#endif
