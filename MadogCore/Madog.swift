//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public final class Madog<T>: ContainerDelegate {
    private let registrar = Registrar<T>()
    private let containerRepository: ContainerUIRepository<T>

    private var currentContainer: ContainerUI<T>?
    private var modalContainers = [ViewController: AnyContext<T>]()

    public init() {
        containerRepository = ContainerUIRepository<T>(registry: registrar.registry)
    }

    public func resolve(resolver: AnyResolver<T>, launchOptions: LaunchOptions? = nil) {
        registrar.resolve(resolver: resolver, launchOptions: launchOptions)
    }

    @discardableResult
    public func addContainerFactory<VC>(
        identifier: ContainerUI<T>.Identifier<VC, SingleUITokenData<T>>,
        factory: AnySingleContainerFactory<T>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerFactory(identifier: identifier.value, factory: factory)
    }

    @discardableResult
    public func addContainerFactory<VC>(
        identifier: ContainerUI<T>.Identifier<VC, MultiUITokenData<T>>,
        factory: AnyMultiContainerFactory<T>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerFactory(identifier: identifier.value, factory: factory)
    }

    @discardableResult
    public func addContainerFactory<VC>(
        identifier: ContainerUI<T>.Identifier<VC, SplitSingleUITokenData<T>>,
        factory: AnySplitSingleContainerFactory<T>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerFactory(identifier: identifier.value, factory: factory)
    }

    @discardableResult
    public func addContainerFactory<VC>(
        identifier: ContainerUI<T>.Identifier<VC, SplitMultiUITokenData<T>>,
        factory: AnySplitMultiContainerFactory<T>
    ) -> Bool where VC: ViewController {
        containerRepository.addContainerFactory(identifier: identifier.value, factory: factory)
    }

    @discardableResult
    public func renderUI<VC, TD>(
        identifier: ContainerUI<T>.Identifier<VC, TD>,
        tokenData: TD,
        in window: Window,
        transition: Transition? = nil,
        customisation: CustomisationBlock<VC>? = nil
    ) -> AnyContext<T>? where VC: ViewController, TD: TokenData {
        guard let container = createUI(
            identifier: identifier,
            tokenData: tokenData,
            isModal: false,
            customisation: customisation
        ) else { return nil }

        window.setRootViewController(container.viewController, transition: transition)
        return container.wrapped()
    }

    public var currentContext: AnyContext<T>? {
        currentContainer
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

    func context(for viewController: ViewController) -> AnyContext<T>? {
        if viewController == currentContainer?.viewController { return currentContainer }
        return modalContainers[viewController]
    }

    func releaseContext(for viewController: ViewController) {
        if viewController == currentContainer?.viewController {
            currentContainer = nil
        } else {
            modalContainers[viewController] = nil
        }
    }

    // MARK: - Private

    private func persist(container: ContainerUI<T>, isModal: Bool) {
        if isModal {
            modalContainers[container.viewController] = container
        } else {
            currentContainer = container
            modalContainers = [:] // Clear old modal contexts
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
