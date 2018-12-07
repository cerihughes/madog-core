//
//  Madog.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public final class Madog<Token> {
    private let registry: ViewControllerRegistry<Token>
    private let factory: MadogUIContextFactory
    private let pageRegistrar = PageRegistrar<Token>()

    public init(resolver: PageResolver & StateResolver) {
        registry = ViewControllerRegistry<Token>()
        factory = MadogUIContextFactoryImplementation<Token>(registry: registry)
        pageRegistrar.loadState(stateResolver: resolver)
        pageRegistrar.registerPages(with: registry, pageResolver: resolver)
    }

    deinit {
        pageRegistrar.unregisterPages(from: self.registry)
    }

    public func renderSinglePageUI(_ uiIdentifier: SinglePageUIIdentifier, with token: Token, in window: UIWindow) -> Bool {
        guard let context = factory.createSinglePageUI(uiIdentifier) as? Context & SinglePageContext,
            context.renderInitialView(with: token) == true else {
            return false
        }

        window.rootViewController = context.viewController
        return true
    }

    public func renderMultiPageUI(_ uiIdentifier: MultiPageUIIdentifier, with tokens: [Token], in window: UIWindow) -> Bool {
        guard let context = factory.createMultiPageUI(uiIdentifier) as? Context & MultiPageContext,
            context.renderInitialViews(with: tokens) == true else {
            return false
        }

        window.rootViewController = context.viewController
        return true
    }
}
