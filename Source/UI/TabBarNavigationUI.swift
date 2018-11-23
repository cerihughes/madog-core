//
//  TabBarNavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias TabBarNavigationUIContext = NavigationContext & ForwardNavigationContext

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
public class TabBarNavigationUI<Token>: TabBarNavigationUIContext {
    private let registry = Registry<Token, TabBarNavigationUIContext, UIViewController>()
    private let tabBarController = UITabBarController()

    public init?(pageResolver: PageResolver) {
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

    public var initialViewController: UITabBarController {
        return tabBarController
    }

    // MARK: NavigationContext

    public func openModal<ContextToken>(with token: ContextToken, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        return nil
    }

    // MARK: ForwardNavigationContext

    public func navigate<ContextToken>(with token: ContextToken, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        guard let token = token as? Token,
            let toViewController = registry.createResult(from: token, context: self),
            let navigationController = fromViewController.navigationController else {
            return nil
        }

        navigationController.pushViewController(toViewController, animated: animated)
        return NavigationTokenImplementation(viewController: toViewController)
    }

}
