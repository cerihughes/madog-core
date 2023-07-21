//
//  Madog.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias NavigationUIContext<T> = ModalContext<T> & ForwardBackNavigationContext<T>
public typealias TabBarUIContext<T> = ModalContext<T> & MultiContext<T>
public typealias TabBarNavigationUIContext<T> = TabBarUIContext<T> & ForwardBackNavigationContext<T>

public typealias AnyNavigationUIContext<T> = any NavigationUIContext<T>
public typealias AnyTabBarUIContext<T> = any TabBarUIContext<T>
public typealias AnyTabBarNavigationUIContext<T> = any TabBarNavigationUIContext<T>

public final class Madog<T>: MadogUIContainerDelegate {
    private let registry = RegistryImplementation<T>()
    private let registrar: Registrar<T>
    private let factory: MadogUIContainerFactory<T>

    private var currentContainer: MadogUIContainer<T>?
    private var modalContainers = [UIViewController: AnyContext<T>]()

    public init() {
        registrar = Registrar(registry: registry)
        factory = MadogUIContainerFactory<T>(registry: registry)
    }

    public func resolve(resolver: AnyResolver<T>, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        registrar.resolve(resolver: resolver, launchOptions: launchOptions)
    }

    @discardableResult
    public func addUICreationFunction(
        identifier: MadogUIIdentifier<some ViewController, some Context<T>, SingleUITokenData<T>, T>,
        function: @escaping SingleVCUIRegistryFunction<T>
    ) -> Bool {
        factory.addUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func addUICreationFunction(
        identifier: MadogUIIdentifier<some ViewController, some Context<T>, MultiUITokenData<T>, T>,
        function: @escaping MultiVCUIRegistryFunction<T>
    ) -> Bool {
        factory.addUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func addUICreationFunction(
        identifier: MadogUIIdentifier<some ViewController, some Context<T>, SplitSingleUITokenData<T>, T>,
        function: @escaping SplitSingleVCUIRegistryFunction<T>
    ) -> Bool {
        factory.addUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func addUICreationFunction(
        identifier: MadogUIIdentifier<some ViewController, some Context<T>, SplitMultiUITokenData<T>, T>,
        function: @escaping SplitMultiVCUIRegistryFunction<T>
    ) -> Bool {
        factory.addUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func renderUI<VC, C, TD>(
        identifier: MadogUIIdentifier<VC, C, TD, T>,
        tokenData: TD,
        in window: UIWindow,
        transition: Transition? = nil,
        customisation: CustomisationBlock<VC>? = nil
    ) -> C? where VC: UIViewController, C: Context<T>, TD: TokenData {
        guard let container = createUI(
            identifier: identifier,
            tokenData: tokenData,
            isModal: false,
            customisation: customisation
        ) else { return nil }

        window.setRootViewController(container.viewController, transition: transition)
        return container as? C
    }

    public var currentContext: AnyContext<T>? {
        currentContainer
    }

    public var serviceProviders: [String: ServiceProvider] {
        registrar.serviceProviders
    }

    // MARK: - MadogUIContainerDelegate

    func createUI<VC, C, TD>(
        identifier: MadogUIIdentifier<VC, C, TD, T>,
        tokenData: TD,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> MadogUIContainer<T>? where VC: UIViewController, C: Context<T>, TD: TokenData {
        guard
            let container = factory.createUI(identifier: identifier, tokenData: tokenData),
            container is C,
            let viewController = container.viewController as? VC
        else {
            return nil
        }

        container.delegate = self
        persist(container: container, isModal: isModal)
        customisation?(viewController)
        return container
    }

    func context(for viewController: UIViewController) -> AnyContext<T>? {
        if viewController == currentContainer?.viewController { return currentContainer }
        return modalContainers[viewController]
    }

    func releaseContext(for viewController: UIViewController) {
        if viewController == currentContainer?.viewController {
            currentContainer = nil
        } else {
            modalContainers[viewController] = nil
        }
    }

    // MARK: - Private

    private func persist(container: MadogUIContainer<T>, isModal: Bool) {
        if isModal {
            modalContainers[container.viewController] = container
        } else {
            currentContainer = container
            modalContainers = [:] // Clear old modal contexts
        }
    }
}

extension UIWindow {
    func setRootViewController(_ viewController: UIViewController, transition: Transition?) {
        rootViewController = viewController

        if let transition {
            UIView.transition(with: self, duration: transition.duration, options: transition.options, animations: {})
        }
    }
}
