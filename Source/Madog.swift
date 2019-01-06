//
//  Madog.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public final class Madog<Token>: MadogUIContainerDelegate {
    private let registry: ViewControllerRegistry
    private let factory: MadogUIContainerFactory<Token>
    private let registrar: Registrar

    private var currentContextUI: MadogUIContainer<Token>?

    public init() {
        registry = ViewControllerRegistry()
        factory = MadogUIContainerFactory<Token>(registry: registry)
        registrar = Registrar()
    }

    public func resolve(resolver: Resolver, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let context = ResourceProviderCreationContextImplementation()
        context.launchOptions = launchOptions
        registrar.createResourceProviders(functions: resolver.resourceProviderCreationFunctions(), context: context)
        registrar.registerViewControllerProviders(with: registry, functions: resolver.viewControllerProviderCreationFunctions())
    }

    deinit {
        registrar.unregisterViewControllerProviders(from: self.registry)
    }

    public func addSingleUICreationFunction(identifier: String, function: @escaping () -> MadogSingleUIContainer<Token>) -> Bool {
        return factory.addSingleUICreationFunction(identifier: identifier, function: function)
    }

    public func addMultiUICreationFunction(identifier: String, function: @escaping () -> MadogMultiUIContainer<Token>) -> Bool {
        return factory.addMultiUICreationFunction(identifier: identifier, function: function)
    }

    public var currentContext: Context? {
        return currentContextUI
    }

    // MARK: - MadogUIContextDelegate

    public func renderUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>, token: Any, in window: UIWindow) -> Bool {
        guard let token = token as? Token,
            let contextUI = factory.createSingleUI(identifier: identifier),
            contextUI.renderInitialView(with: token) == true else {
                return false
        }

        contextUI.delegate = self
        currentContextUI = contextUI

        guard let viewController = contextUI.viewController as? VC else {
            return false
        }
        identifier.customisation(viewController)

        window.rootViewController = viewController
        return true
    }

    public func renderUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>, tokens: [Any], in window: UIWindow) -> Bool {
        guard let tokens = tokens as? [Token],
            let contextUI = factory.createMultiUI(identifier: identifier),
            contextUI.renderInitialViews(with: tokens) == true else {
                return false
        }

        contextUI.delegate = self
        currentContextUI = contextUI

        guard let viewController = contextUI.viewController as? VC else {
            return false
        }
        identifier.customisation(viewController)

        window.rootViewController = viewController
        return true
    }
}
