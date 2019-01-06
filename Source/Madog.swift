//
//  Madog.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public final class Madog<Token>: MadogUIContextDelegate {
    private let registry: ViewControllerRegistry
    private let factory: MadogUIContextFactory<Token>
    private let registrar: Registrar

    private var currentContextUI: MadogUIContext<Token>?

    public init() {
        registry = ViewControllerRegistry()
        factory = MadogUIContextFactory<Token>(registry: registry)
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

    public func addSingleUICreationFunction(identifier: String, function: @escaping () -> MadogSingleUIContext<Token>) -> Bool {
        return factory.addSingleUICreationFunction(identifier: identifier, function: function)
    }

    public func addMultiUICreationFunction(identifier: String, function: @escaping () -> MadogMultiUIContext<Token>) -> Bool {
        return factory.addMultiUICreationFunction(identifier: identifier, function: function)
    }

    public var currentContext: Context? {
        return currentContextUI
    }

    // MARK: - MadogUIContextDelegate

    public func renderSingleUI<VC: UIViewController>(_ uiIdentifier: SingleUIIdentifier<VC>, with token: Any, in window: UIWindow) -> Bool {
        guard let token = token as? Token,
            let contextUI = factory.createSingleUI(uiIdentifier),
            contextUI.renderInitialView(with: token) == true else {
                return false
        }

        contextUI.delegate = self
        currentContextUI = contextUI

        guard let viewController = contextUI.viewController as? VC else {
            return false
        }
        uiIdentifier.customisation(viewController)

        window.rootViewController = viewController
        return true
    }

    public func renderMultiUI<VC: UIViewController>(_ uiIdentifier: MultiUIIdentifier<VC>, with tokens: [Any], in window: UIWindow) -> Bool {
        guard let tokens = tokens as? [Token],
            let contextUI = factory.createMultiUI(uiIdentifier),
            contextUI.renderInitialViews(with: tokens) == true else {
                return false
        }

        contextUI.delegate = self
        currentContextUI = contextUI

        guard let viewController = contextUI.viewController as? VC else {
            return false
        }
        uiIdentifier.customisation(viewController)

        window.rootViewController = viewController
        return true
    }
}
