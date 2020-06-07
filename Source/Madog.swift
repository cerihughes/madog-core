//
//  Madog.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias BasicUIContext = Context & ModalContext
public typealias NavigationUIContext = BasicUIContext & ForwardBackNavigationContext
public typealias TabBarUIContext = BasicUIContext & MultiContext
public typealias TabBarNavigationUIContext = TabBarUIContext & ForwardBackNavigationContext

public final class Madog<Token>: MadogUIContainerDelegate {
    private let registry = Registry<Token>()
    private let registrar: Registrar<Token>
    private let factory: MadogUIContainerFactory<Token>

    private var currentContainer: MadogUIContainer?
    private var modalContainers = [UIViewController: Context]()

    public init() {
        registrar = Registrar(registry: registry)
        factory = MadogUIContainerFactory<Token>(registry: registry)
    }

    public func resolve(resolver: Resolver<Token>, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        registrar.resolve(resolver: resolver, launchOptions: launchOptions)
    }

    @discardableResult
    public func addUICreationFunction(identifier: String, function: @escaping SingleVCUIRegistryFunction<Token>) -> Bool {
        factory.addUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func addUICreationFunction(identifier: String, function: @escaping MultiVCUIRegistryFunction<Token>) -> Bool {
        factory.addUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func addUICreationFunction(identifier: String, function: @escaping SplitSingleVCUIRegistryFunction<Token>) -> Bool {
        factory.addUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func addUICreationFunction(identifier: String, function: @escaping SplitMultiVCUIRegistryFunction<Token>) -> Bool {
        factory.addUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func renderUI<VC: UIViewController>(identifier: MadogUIIdentifier<VC>,
                                               tokenData: TokenData,
                                               in window: UIWindow,
                                               transition: Transition? = nil,
                                               customisation: CustomisationBlock<VC>? = nil) -> Context? {
        guard let context = createUI(identifier: identifier,
                                     tokenData: tokenData,
                                     isModal: false,
                                     customisation: customisation) else {
            return nil
        }
        window.setRootViewController(context.viewController, transition: transition)
        return context
    }

    public var currentContext: Context? {
        currentContainer
    }

    public var serviceProviders: [String: ServiceProvider] {
        registrar.serviceProviders
    }

    // MARK: - MadogUIContainerDelegate

    func createUI<VC: UIViewController>(identifier: MadogUIIdentifier<VC>,
                                        tokenData: TokenData,
                                        isModal: Bool,
                                        customisation: CustomisationBlock<VC>?) -> MadogUIContainer? {
        guard let container = factory.createUI(identifier: identifier, tokenData: tokenData) else {
            return nil
        }

        container.delegate = self
        persist(container: container, isModal: isModal)

        guard let viewController = container.viewController as? VC else {
            return nil
        }
        customisation?(viewController)
        return container
    }

    func releaseContext(for viewController: UIViewController) {
        if viewController == currentContainer?.viewController {
            currentContainer = nil
        } else {
            modalContainers[viewController] = nil
        }
    }

    // MARK: - Private

    private func persist(container: MadogUIContainer, isModal: Bool) {
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

        if let transition = transition {
            UIView.transition(with: self, duration: transition.duration, options: transition.options, animations: {})
        }
    }
}
