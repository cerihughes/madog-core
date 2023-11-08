//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public final class Madog<T>: ContainerDelegate {
    private let registrar = Registrar<T>()
    private let containerRepository: ContainerUIRepository<T>

    private var container: ContainerUI<T>?
    private var modalContainers = [ViewController: AnyContainer<T>]()

    public init() {
        containerRepository = ContainerUIRepository<T>(registry: registrar.registry)
    }

    public func resolve(resolver: AnyResolver<T>, launchOptions: LaunchOptions? = nil) {
        registrar.resolve(resolver: resolver, launchOptions: launchOptions)
    }

    @discardableResult
    public func addContainerUIFactory<VC>(
        identifier: ContainerUI<T>.Identifier<VC, SingleUITokenData<T>>,
        factory: AnySingleContainerUIFactory<T>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerUIFactory(identifier: identifier.value, factory: factory)
    }

    @discardableResult
    public func addContainerUIFactory<VC>(
        identifier: ContainerUI<T>.Identifier<VC, MultiUITokenData<T>>,
        factory: AnyMultiContainerUIFactory<T>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerUIFactory(identifier: identifier.value, factory: factory)
    }

    @discardableResult
    public func addContainerUIFactory<VC>(
        identifier: ContainerUI<T>.Identifier<VC, SplitSingleUITokenData<T>>,
        factory: AnySplitSingleContainerUIFactory<T>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerUIFactory(identifier: identifier.value, factory: factory)
    }

    @discardableResult
    public func addContainerUIFactory<VC>(
        identifier: ContainerUI<T>.Identifier<VC, SplitMultiUITokenData<T>>,
        factory: AnySplitMultiContainerUIFactory<T>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerUIFactory(identifier: identifier.value, factory: factory)
    }

    @discardableResult
    public func renderUI<VC, TD>(
        identifier: ContainerUI<T>.Identifier<VC, TD>,
        tokenData: TD,
        in window: Window,
        transition: Transition? = nil,
        customisation: CustomisationBlock<VC>? = nil
    ) -> AnyContainer<T>? where VC: ViewController, TD: TokenData {
        guard let container = createUI(
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

    // MARK: - MadogUIContainerDelegate

    func createUI<VC, TD>(
        identifier: ContainerUI<T>.Identifier<VC, TD>,
        tokenData: TD,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> ContainerUI<T>? where VC: ViewController, TD: TokenData {
        guard
            let container = containerRepository.createContainer(identifier: identifier.value, tokenData: tokenData),
            let viewController = container.viewController as? VC
        else {
            return nil
        }

        container.delegate = self
        persist(container: container, isModal: isModal)
        customisation?(viewController)
        return container
    }

    func container(for viewController: ViewController) -> AnyContainer<T>? {
        if viewController == container?.viewController { return container }
        return modalContainers[viewController]
    }

    func releaseContainer(for viewController: ViewController) {
        if viewController == container?.viewController {
            container = nil
        } else {
            modalContainers[viewController] = nil
        }
    }

    // MARK: - Private

    private func persist(container: ContainerUI<T>, isModal: Bool) {
        if isModal {
            modalContainers[container.viewController] = container
        } else {
            self.container = container
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
