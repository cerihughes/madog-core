//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public final class Madog<T>: ContainerUIDelegate {
    private let registrar = Registrar<T>()
    private let contentFactory: ContainerUIContentFactoryImplementation<T>
    private let containerRepository: ContainerUIRepository<T>

    private var container: AnyContainer<T>?
    private var containerViewController: ViewController?
    private var modalContainers = [ViewController: AnyContainer<T>]()

    public init() {
        contentFactory = ContainerUIContentFactoryImplementation(registry: registrar.registry)
        containerRepository = ContainerUIRepository<T>(registry: registrar.registry, contentFactory: contentFactory)
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
    ) -> AnyContainer<T>? where VC: ViewController, TD: TokenData {
        guard let container = createContainer(
            identifiableToken: .init(identifier: identifier, data: tokenData),
            isModal: false,
            customisation: customisation
        ) else { return nil }

        window.setRootViewController(container.containerViewController, transition: transition)
        return container.proxy()
    }

    public var currentContainer: AnyContainer<T>? {
        container
    }

    public var serviceProviders: [String: ServiceProvider] {
        registrar.serviceProviders
    }

    // MARK: - ContainerDelegate

    func createContainer<VC, TD>(
        identifiableToken: IdentifiableToken<T, TD, VC>,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> ContainerUI<T, TD, VC>? where VC: ViewController, TD: TokenData {
        guard let container = containerRepository.createContainer(identifiableToken: identifiableToken) else {
            return nil
        }

        let containerViewController = container.containerViewController
        container.delegate = self
        persist(container: container, containerViewController: containerViewController, isModal: isModal)
        customisation?(containerViewController)
        return container
    }

    func container(for viewController: ViewController) -> AnyContainer<T>? {
        if viewController == containerViewController { return container }
        return modalContainers[viewController]
    }

    func releaseContainer(for viewController: ViewController) {
        if viewController == containerViewController {
            container = nil
        } else {
            modalContainers[viewController] = nil
        }
    }

    // MARK: - Private

    private func persist(container: AnyContainer<T>, containerViewController: ViewController, isModal: Bool) {
        if isModal {
            modalContainers[containerViewController] = container
        } else {
            self.container = container
            self.containerViewController = containerViewController
            modalContainers = [:] // Clear old modal containers
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
