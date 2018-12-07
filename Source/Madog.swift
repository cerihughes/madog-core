//
//  Madog.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public final class Madog: MadogUIContextDelegate {
    private let registry: ViewControllerRegistry
    private let factory: MadogUIContextFactory
    private let pageRegistrar = PageRegistrar()

    private var currentContextUI: MadogUIContext?

    public init(resolver: PageResolver & StateResolver) {
        registry = ViewControllerRegistry()
        factory = MadogUIContextFactoryImplementation(registry: registry)
        pageRegistrar.loadState(stateResolver: resolver)
        pageRegistrar.registerPages(with: registry, pageResolver: resolver)
    }

    deinit {
        pageRegistrar.unregisterPages(from: self.registry)
    }

    // MARK: - MadogUIContextDelegate

    public func renderSinglePageUI(_ uiIdentifier: SinglePageUIIdentifier, with token: Any, in window: UIWindow) -> Bool {
        guard var contextUI = factory.createSinglePageUI(uiIdentifier),
            contextUI.renderInitialView(with: token) == true else {
                return false
        }

        contextUI.delegate = self
        currentContextUI = contextUI
        window.rootViewController = contextUI.viewController
        return true
    }

    public func renderMultiPageUI(_ uiIdentifier: MultiPageUIIdentifier, with tokens: [Any], in window: UIWindow) -> Bool {
        guard var contextUI = factory.createMultiPageUI(uiIdentifier),
            contextUI.renderInitialViews(with: tokens) == true else {
                return false
        }

        contextUI.delegate = self
        currentContextUI = contextUI
        window.rootViewController = contextUI.viewController
        return true
    }
}
