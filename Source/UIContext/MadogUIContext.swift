//
//  MadogUIContext.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol MadogUIContextDelegate: class {
    func renderSinglePageUI<VC: UIViewController>(_ uiIdentifier: SinglePageUIIdentifier<VC>, with token: Any, in window: UIWindow) -> Bool
    func renderMultiPageUI<VC: UIViewController>(_ uiIdentifier: MultiPageUIIdentifier<VC>, with tokens: [Any], in window: UIWindow) -> Bool
}

open class MadogUIContext<Token>: Context {
    internal weak var delegate: MadogUIContextDelegate?
    internal let viewController: UIViewController
    public let registry: ViewControllerRegistry

    public init(registry: ViewControllerRegistry, viewController: UIViewController) {
        self.registry = registry
        self.viewController = viewController
    }

    public func change<VC: UIViewController>(to uiIdentifier: SinglePageUIIdentifier<VC>, with token: Any) -> Bool {
        guard let delegate = delegate, let window = viewController.view.window else {
            return false
        }

        return delegate.renderSinglePageUI(uiIdentifier, with: token, in: window)
    }

    public func change<VC: UIViewController>(to uiIdentifier: MultiPageUIIdentifier<VC>, with tokens: [Any]) -> Bool {
        guard let delegate = delegate, let window = viewController.view.window else {
            return false
        }

        return delegate.renderMultiPageUI(uiIdentifier, with: tokens, in: window)
    }

    public final func createNavigationToken(for viewController: UIViewController) -> NavigationToken {
        return NavigationTokenImplementation(viewController: viewController)
    }
}

open class MadogSinglePageUIContext<Token>: MadogUIContext<Token> {
    open func renderInitialView(with token: Token) -> Bool {
        return false
    }
}

open class MadogMultiPageUIContext<Token>: MadogUIContext<Token> {
    open func renderInitialViews(with tokens: [Token]) -> Bool {
        return false
    }
}
