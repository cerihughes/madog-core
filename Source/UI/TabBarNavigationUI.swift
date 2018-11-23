//
//  TabBarNavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

typealias TabBarNavigationUIContext = NavigationContext & ForwardNavigationContext

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class TabBarNavigationUI<Token>: TabBarNavigationUIContext {
    private let registry = Registry<Token, TabBarNavigationUIContext, UIViewController>()
    private let tabBarController = UITabBarController()

    init?(pageResolver: PageResolver) {
        let pageFactories = pageResolver.pageFactories()
        for pageFactory in pageFactories {
            let page = pageFactory.createPage()
            page.register(with: registry)
        }

        guard let initialViewControllers = registry.createGlobalResults(context: self),
            initialViewControllers.count > 0 else {
                return nil
        }

        tabBarController.viewControllers = initialViewControllers
    }

    var initialViewController: UIViewController {
        return tabBarController
    }

    // MARK: NavigationContext

    func openModal<ContextToken>(with token: ContextToken, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        return nil
    }

    // MARK: ForwardNavigationContext

    func navigate<ContextToken>(with token: ContextToken, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        guard let token = token as? Token,
            let toViewController = registry.createResult(from: token, context: self),
            let navigationController = fromViewController.navigationController else {
            return nil
        }

        navigationController.pushViewController(toViewController, animated: animated)
        return NavigationTokenImplementation(viewController: toViewController)
    }

}
