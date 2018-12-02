//
//  NavigationContext.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol Context {
    var viewController: UIViewController {get}

    func change<Token>(to ui: SinglePageUI, with token: Token) -> Bool
    func change<Token>(to ui: MultiPageUI, with tokens: [Token]) -> Bool
    func openModal<Token>(with token: Token, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
}

public protocol SinglePageContext: Context {
    func renderInitialView<Token>(with token: Token) -> Bool
}

public protocol MultiPageContext: Context {
    func renderInitialViews<Token>(with tokens: [Token]) -> Bool
}

public protocol ForwardBackNavigationContext: Context {
    func navigateForward<Token>(with token: Token, animated: Bool) -> NavigationToken?
    func navigateBack(animated: Bool) -> Bool
}

public protocol NavigationContext: SinglePageContext, ForwardBackNavigationContext {
}

public protocol TabBarNavigationContext: MultiPageContext, ForwardBackNavigationContext {
    func navigateForward<Token>(with token: Token, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
    func navigateBack(from fromViewController: UIViewController, animated: Bool) -> Bool
}
