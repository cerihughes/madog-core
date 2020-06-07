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
public typealias SplitSingleVCUIRegistryFunction<Token> = (Registry<Token>, Token, Token) -> MadogModalUIContainer<Token>?
public typealias SplitMultiVCUIRegistryFunction<Token> = (Registry<Token>, Token, [Token]) -> MadogModalUIContainer<Token>?

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
                                               token: Any,
                                               in window: UIWindow,
                                               transition: Transition? = nil,
                                               customisation: CustomisationBlock<VC>? = nil) -> Context? {
        guard let context = createUI(identifier: identifier,
                                     token: token,
                                     isModal: false,
                                     customisation: customisation) else {
            return nil
        }
        window.setRootViewController(context.viewController, transition: transition)
        return context
    }

    @discardableResult
    public func renderUI<VC: UIViewController>(identifier: MadogUIIdentifier<VC>,
                                               tokens: [Any],
                                               in window: UIWindow,
                                               transition: Transition? = nil,
                                               customisation: CustomisationBlock<VC>? = nil) -> Context? {
        guard let context = createUI(identifier: identifier,
                                     tokens: tokens,
                                     isModal: false,
                                     customisation: customisation) else {
            return nil
        }
        window.setRootViewController(context.viewController, transition: transition)
        return context
    }

    @discardableResult
    public func renderUI<VC: UIViewController>(identifier: MadogUIIdentifier<VC>,
                                               primaryToken: Any,
                                               secondaryToken: Any,
                                               in window: UIWindow,
                                               transition: Transition? = nil,
                                               customisation: CustomisationBlock<VC>? = nil) -> Context? {
        guard let context = createUI(identifier: identifier,
                                     primaryToken: primaryToken,
                                     secondaryToken: secondaryToken,
                                     isModal: false,
                                     customisation: customisation) else {
            return nil
        }
        window.setRootViewController(context.viewController, transition: transition)
        return context
    }

    @discardableResult
    public func renderUI<VC: UIViewController>(identifier: MadogUIIdentifier<VC>,
                                               primaryToken: Any,
                                               secondaryTokens: [Any],
                                               in window: UIWindow,
                                               transition: Transition? = nil,
                                               customisation: CustomisationBlock<VC>? = nil) -> Context? {
        guard let context = createUI(identifier: identifier,
                                     primaryToken: primaryToken,
                                     secondaryTokens: secondaryTokens,
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
                                        token: Any,
                                        isModal: Bool,
                                        customisation: CustomisationBlock<VC>?) -> MadogUIContainer? {
        guard let token = token as? Token,
            let container = factory.createSingleUI(identifier: identifier, token: token) else {
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

    func createUI<VC: UIViewController>(identifier: MadogUIIdentifier<VC>,
                                        tokens: [Any],
                                        isModal: Bool,
                                        customisation: CustomisationBlock<VC>?) -> MadogUIContainer? {
        guard let tokens = tokens as? [Token],
            let container = factory.createMultiUI(identifier: identifier, tokens: tokens) else {
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

    func createUI<VC: UIViewController>(identifier: MadogUIIdentifier<VC>,
                                        primaryToken: Any,
                                        secondaryToken: Any,
                                        isModal: Bool,
                                        customisation: CustomisationBlock<VC>?) -> MadogUIContainer? {
        guard let primaryToken = primaryToken as? Token,
            let secondaryToken = secondaryToken as? Token,
            let container = factory.createSplitSingleUI(identifier: identifier, primaryToken: primaryToken, secondaryToken: secondaryToken) else {
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

    func createUI<VC: UIViewController>(identifier: MadogUIIdentifier<VC>,
                                        primaryToken: Any,
                                        secondaryTokens: [Any],
                                        isModal: Bool,
                                        customisation: CustomisationBlock<VC>?) -> MadogUIContainer? {
        guard let primaryToken = primaryToken as? Token,
            let secondaryTokens = secondaryTokens as? [Token],
            let container = factory.createSplitMultiUI(identifier: identifier, primaryToken: primaryToken, secondaryTokens: secondaryTokens) else {
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
