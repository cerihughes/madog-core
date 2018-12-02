//
//  TabBarNavigationContextImplementation.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal class TabBarNavigationContextImplementation<Token>: ModalContextImplementation, TabBarNavigationContext {
    internal let tabBarController = UITabBarController()
    private let registry: ViewControllerRegistry<Token>

    internal init(registry: ViewControllerRegistry<Token>) {
        self.registry = registry

        super.init(viewController: self.tabBarController)
    }

    // MARK: TabBarNavigationContext

    public func navigateForward<ContextToken>(with token: ContextToken, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        guard let token = token as? Token,
            let toViewController = registry.createViewController(from: token, context: self),
            let navigationController = fromViewController.navigationController else {
                return nil
        }

        navigationController.pushViewController(toViewController, animated: animated)
        return NavigationTokenImplementation(viewController: toViewController)
    }

    public func navigateBack(animated: Bool) -> Bool {
        guard let navigationController = tabBarController.selectedViewController as? UINavigationController else {
            return false
        }
        return navigationController.popViewController(animated: animated) != nil
    }
}
