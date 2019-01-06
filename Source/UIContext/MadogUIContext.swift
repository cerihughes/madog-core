//
//  MadogUIContext.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol MadogUIContextDelegate: class {
    func renderUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>, token: Any, in window: UIWindow) -> Bool
    func renderUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>, tokens: [Any], in window: UIWindow) -> Bool
}

open class MadogUIContext<Token>: Context {
    internal weak var delegate: MadogUIContextDelegate?
    internal let viewController: UIViewController
    internal var internalRegistry: ViewControllerRegistry!

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public var registry: ViewControllerRegistry {
        return internalRegistry
    }

    public func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any) -> Bool {
        guard let delegate = delegate, let window = viewController.view.window else {
            return false
        }

        return delegate.renderUI(identifier: identifier, token: token, in: window)
    }

    public func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any]) -> Bool {
        guard let delegate = delegate, let window = viewController.view.window else {
            return false
        }

        return delegate.renderUI(identifier: identifier, tokens: tokens, in: window)
    }

    public final func createNavigationToken(for viewController: UIViewController) -> NavigationToken {
        return NavigationTokenImplementation(viewController: viewController)
    }
}

open class MadogSingleUIContext<Token>: MadogUIContext<Token> {
    open func renderInitialView(with token: Token) -> Bool {
        return false
    }
}

open class MadogMultiUIContext<Token>: MadogUIContext<Token> {
    open func renderInitialViews(with tokens: [Token]) -> Bool {
        return false
    }
}
