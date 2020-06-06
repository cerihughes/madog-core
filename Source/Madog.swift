//
//  Madog.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias SingleVCUIRegistryFunction<Token> = (Registry<Token>, Token) -> MadogModalUIContainer<Token>?
public typealias MultiVCUIRegistryFunction<Token> = (Registry<Token>, [Token]) -> MadogModalUIContainer<Token>?

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
    public func addSingleUICreationFunction(identifier: String, function: @escaping SingleVCUIRegistryFunction<Token>) -> Bool {
        factory.addSingleUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func addMultiUICreationFunction(identifier: String, function: @escaping MultiVCUIRegistryFunction<Token>) -> Bool {
        factory.addMultiUICreationFunction(identifier: identifier, function: function)
    }

    @discardableResult
    public func renderUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>, token: Any, in window: UIWindow, transition: Transition? = nil) -> Context? {
        guard let context = createUI(identifier: identifier, token: token, isModal: false) else {
            return nil
        }
        window.setRootViewController(context.viewController, transition: transition)
        return context
    }

    @discardableResult
    public func renderUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>,
                                               tokens: [Any],
                                               in window: UIWindow,
                                               transition: Transition? = nil) -> Context? {
        guard let context = createUI(identifier: identifier, tokens: tokens, isModal: false) else {
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

    func createUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>, token: Any, isModal: Bool) -> MadogUIContainer? {
        guard let token = token as? Token,
            let container = factory.createSingleUI(identifier: identifier, token: token) else {
            return nil
        }

        container.delegate = self
        persist(container: container, isModal: isModal)

        guard let viewController = container.viewController as? VC else {
            return nil
        }
        identifier.customisation(viewController)
        return container
    }

    func createUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>, tokens: [Any], isModal: Bool) -> MadogUIContainer? {
        guard let tokens = tokens as? [Token],
            let container = factory.createMultiUI(identifier: identifier, tokens: tokens) else {
            return nil
        }

        container.delegate = self
        persist(container: container, isModal: isModal)

        guard let viewController = container.viewController as? VC else {
            return nil
        }
        identifier.customisation(viewController)
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
