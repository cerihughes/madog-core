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
    private let pageRegistrar: PageRegistrar

    private var currentContextUI: MadogUIContext?

    public init(resolver: Resolver) {
        registry = ViewControllerRegistry()
        factory = MadogUIContextFactoryImplementation(registry: registry)
        pageRegistrar = PageRegistrar(resolver: resolver)
        pageRegistrar.loadState()
        pageRegistrar.registerPages(with: registry)
    }

    deinit {
        pageRegistrar.unregisterPages(from: self.registry)
    }

    // MARK: - MadogUIContextDelegate

    public func renderSinglePageUI<VC: UIViewController>(_ uiIdentifier: SinglePageUIIdentifier<VC>, with token: Any, in window: UIWindow) -> Bool {
        guard var contextUI = factory.createSinglePageUI(uiIdentifier),
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
        guard var contextUI = factory.createMultiPageUI(uiIdentifier),
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
