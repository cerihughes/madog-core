//
//  NavigationContext.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol ModalContext {
    func openModal<Token>(with token: Token, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
}

public protocol NavigationContext {
    func navigateForward<Token>(with token: Token, animated: Bool) -> NavigationToken?
    func navigateBack(animated: Bool) -> Bool
}

public protocol TabBarNavigationContext {
    func navigateForward<Token>(with token: Token, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
    func navigateBack(animated: Bool) -> Bool
}
