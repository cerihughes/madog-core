//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public final class Madog<T>: ContainerDelegate {
    private let registrar = Registrar<T>()
    private let containerRepository: ContainerUIRepository<T>

    private var container: AnyContainer<T>?
    private var containerViewController: ViewController?
    private var modalContainers = [ViewController: AnyContainer<T>]()

    public init() {
        containerRepository = ContainerUIRepository<T>(registry: registrar.registry)
    }

    public func resolve(resolver: AnyResolver<T>, launchOptions: LaunchOptions? = nil) {
        registrar.resolve(resolver: resolver, launchOptions: launchOptions)
    }

    @discardableResult
    public func addContainerUIFactory<VC>(
        identifier: ContainerUI<T, VC>.Identifier<SingleUITokenData<T>>,
        factory: AnySingleContainerUIFactory<T, VC>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerUIFactory(identifier: identifier.value, factory: factory.typeErased())
    }

    @discardableResult
    public func addContainerUIFactory<VC>(
        identifier: ContainerUI<T, VC>.Identifier<MultiUITokenData<T>>,
        factory: AnyMultiContainerUIFactory<T, VC>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerUIFactory(identifier: identifier.value, factory: factory.typeErased())
    }

    @discardableResult
    public func addContainerUIFactory<VC>(
        identifier: ContainerUI<T, VC>.Identifier<SplitSingleUITokenData<T>>,
        factory: AnySplitSingleContainerUIFactory<T, VC>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerUIFactory(identifier: identifier.value, factory: factory.typeErased())
    }

    @discardableResult
    public func addContainerUIFactory<VC>(
        identifier: ContainerUI<T, VC>.Identifier<SplitMultiUITokenData<T>>,
        factory: AnySplitMultiContainerUIFactory<T, VC>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerUIFactory(identifier: identifier.value, factory: factory.typeErased())
    }

    @discardableResult
    public func renderUI<VC, TD>(
        identifier: ContainerUI<T, VC>.Identifier<TD>,
        tokenData: TD,
        in window: Window,
        transition: Transition? = nil,
        customisation: CustomisationBlock<VC>? = nil
    ) -> AnyContainer<T>? where VC: ViewController, TD: TokenData {
        guard let container = createContainer(
            identifier: identifier,
            tokenData: tokenData,
            isModal: false,
            customisation: customisation
        ) else { return nil }

        window.setRootViewController(container.viewController, transition: transition)
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
        identifier: ContainerUI<T, VC>.Identifier<TD>,
        tokenData: TD,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> ContainerUI<T, VC>? where VC: ViewController, TD: TokenData {
        guard let container = containerRepository.createContainer(identifier: identifier, tokenData: tokenData) else {
            return nil
        }

        let viewController = container.viewController
        container.delegate = self
        persist(container: container, containerViewController: viewController, isModal: isModal)
        customisation?(viewController)
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
