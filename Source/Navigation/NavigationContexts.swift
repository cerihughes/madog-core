//
//  NavigationContexts.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol Context {
    func change(to uiIdentifier: SinglePageUIIdentifier, with token: Any) -> Bool
    func change(to uiIdentifier: MultiPageUIIdentifier, with tokens: [Any]) -> Bool
    func openModal(with token: Any, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
}

public protocol SinglePageContext {
    func renderInitialView(with token: Any) -> Bool
}

public protocol MultiPageContext {
    func renderInitialViews(with tokens: [Any]) -> Bool
}

public protocol ForwardBackNavigationContext {
    func navigateForward(with token: Any, animated: Bool) -> NavigationToken?
    func navigateBack(animated: Bool) -> Bool
}
