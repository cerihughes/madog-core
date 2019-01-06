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
    private let pageRegistrar: PageRegistrar

    private var currentContextUI: MadogUIContext<Token>?

    public init() {
        registry = ViewControllerRegistry()
        factory = MadogUIContextFactory<Token>(registry: registry)
        pageRegistrar = PageRegistrar()
    }

    public func resolve(resolver: Resolver, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let stateCreationContext = StateCreationContextImplementation()
        stateCreationContext.launchOptions = launchOptions
        pageRegistrar.createState(functions: resolver.stateCreationFunctions(), context: stateCreationContext)
        pageRegistrar.registerPages(with: registry, functions: resolver.pageCreationFunctions())
    }

    deinit {
        pageRegistrar.unregisterPages(from: self.registry)
    }

    public func addSinglePageUICreationFunction(identifier: String, function: @escaping () -> MadogSinglePageUIContext<Token>) -> Bool {
        return factory.addSinglePageUICreationFunction(identifier: identifier, function: function)
    }

    public func addMultiPageUICreationFunction(identifier: String, function: @escaping () -> MadogMultiPageUIContext<Token>) -> Bool {
        return factory.addMultiPageUICreationFunction(identifier: identifier, function: function)
    }

    public var currentContext: Context? {
        return currentContextUI
    }

    // MARK: - MadogUIContextDelegate

    public func renderSinglePageUI<VC: UIViewController>(_ uiIdentifier: SinglePageUIIdentifier<VC>, with token: Any, in window: UIWindow) -> Bool {
        guard let token = token as? Token,
            let contextUI = factory.createSinglePageUI(uiIdentifier),
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

    public func renderMultiPageUI<VC: UIViewController>(_ uiIdentifier: MultiPageUIIdentifier<VC>, with tokens: [Any], in window: UIWindow) -> Bool {
        guard let tokens = tokens as? [Token],
            let contextUI = factory.createMultiPageUI(uiIdentifier),
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
