//
//  Madog.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public final class Madog<Token>: ContextUIDelegate {
    private let registry: ViewControllerRegistry<Token>
    private let factory: Factory
    private let pageRegistrar = PageRegistrar<Token>()

    private var currentContext: Context?

    public init(resolver: PageResolver & StateResolver) {
        registry = ViewControllerRegistry<Token>()
        factory = MadogFactory<Token>(registry: registry)
        pageRegistrar.loadState(stateResolver: resolver)
        pageRegistrar.registerPages(with: registry, pageResolver: resolver)
    }

    deinit {
        pageRegistrar.unregisterPages(from: self.registry)
    }

    // MARK: - ContextUIDelegate

    public func renderSinglePageUI<Token>(_ uiIdentifier: SinglePageUIIdentifier, with token: Token, in window: UIWindow) -> Bool {
        guard let context = factory.createSinglePageUI(uiIdentifier) as? Context & SinglePageContextUI,
            context.renderInitialView(with: token) == true else {
            return false
        }

        context.delegate = self
        currentContext = context
        window.rootViewController = context.viewController
        return true
    }

    public func renderMultiPageUI<Token>(_ uiIdentifier: MultiPageUIIdentifier, with tokens: [Token], in window: UIWindow) -> Bool {
        guard let context = factory.createMultiPageUI(uiIdentifier) as? Context & MultiPageContextUI,
            context.renderInitialViews(with: tokens) == true else {
            return false
        }

        context.delegate = self
        currentContext = context
        window.rootViewController = context.viewController
        return true
    }
}
