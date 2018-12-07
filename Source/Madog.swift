//
//  Madog.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public final class Madog<Token>: MadogUIContextDelegate {
    private let registry: ViewControllerRegistry<Token>
    private let factory: MadogUIContextFactory
    private let pageRegistrar = PageRegistrar<Token>()

    private var currentContextUI: MadogUIContext?

    public init(resolver: PageResolver & StateResolver) {
        registry = ViewControllerRegistry<Token>()
        factory = MadogUIContextFactoryImplementation<Token>(registry: registry)
        pageRegistrar.loadState(stateResolver: resolver)
        pageRegistrar.registerPages(with: registry, pageResolver: resolver)
    }

    deinit {
        pageRegistrar.unregisterPages(from: self.registry)
    }

    // MARK: - ContextUIDelegate

    public func renderSinglePageUI<T>(_ uiIdentifier: SinglePageUIIdentifier, with token: T, in window: UIWindow) -> Bool {
        guard var contextUI = factory.createSinglePageUI(uiIdentifier),
            contextUI.renderInitialView(with: token) == true else {
            return false
        }

        contextUI.delegate = self
        currentContextUI = contextUI
        window.rootViewController = contextUI.viewController
        return true
    }

    public func renderMultiPageUI<T>(_ uiIdentifier: MultiPageUIIdentifier, with tokens: [T], in window: UIWindow) -> Bool {
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
