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

    func openModal<Token>(with token: Token, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
}

public protocol SinglePageContext: Context {
    func renderInitialView<Token>(with token: Token) -> Bool
}

public protocol MultiPageContext: Context {
    func renderInitialViews<Token>(with tokens: [Token]) -> Bool
}

public protocol NavigationContext: SinglePageContext {
    func navigateForward<Token>(with token: Token, animated: Bool) -> NavigationToken?
    func navigateBack(animated: Bool) -> Bool
}

public protocol TabBarNavigationContext: MultiPageContext {
    func navigateForward<Token>(with token: Token, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
    func navigateBack(animated: Bool) -> Bool
}
