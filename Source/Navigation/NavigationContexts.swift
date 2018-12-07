//
//  NavigationContext.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol Context {
    func change<Token>(to uiIdentifier: SinglePageUIIdentifier, with token: Token) -> Bool
    func change<Token>(to uiIdentifier: MultiPageUIIdentifier, with tokens: [Token]) -> Bool
    func openModal<Token>(with token: Token, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
}

public protocol SinglePageContext {
    func renderInitialView<Token>(with token: Token) -> Bool
}

public protocol MultiPageContext {
    func renderInitialViews<Token>(with tokens: [Token]) -> Bool
}

public protocol ForwardBackNavigationContext {
    func navigateForward<Token>(with token: Token, animated: Bool) -> NavigationToken?
    func navigateBack(animated: Bool) -> Bool
}

public protocol NavigationContext: class, Context, SinglePageContext, ForwardBackNavigationContext {
}

public protocol TabBarNavigationContext: class, Context, MultiPageContext, ForwardBackNavigationContext {
}
