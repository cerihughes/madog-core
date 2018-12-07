//
//  TabBarNavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

protocol TabBarNavigationContext: Context, MultiPageContext, ForwardBackNavigationContext {}

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class TabBarNavigationUI<Token>: TabBarNavigationContext {
    private let tabBarController = UITabBarController()
    private let registry: ViewControllerRegistry<Token>
    private let factory: Factory

    init(registry: ViewControllerRegistry<Token>, factory: Factory) {
        self.registry = registry
        self.factory = factory
    }

    // MARK: - Context

    var viewController: UIViewController {
        return tabBarController
    }

    func change<T>(to uiIdentifier: SinglePageUIIdentifier, with token: T) -> Bool {
        guard let window = viewController.view.window,
            let context = factory.createSinglePageUI(uiIdentifier) as? Context & SinglePageContext,
            context.renderInitialView(with: token) == true else {
                return false
        }

        window.rootViewController = context.viewController
        return true
    }

    func change<T>(to uiIdentifier: MultiPageUIIdentifier, with tokens: [T]) -> Bool {
        if uiIdentifier == .tabBarControllerIdentifier {
            return renderInitialViews(with: tokens)
        }

        guard let window = viewController.view.window,
            let context = factory.createMultiPageUI(uiIdentifier) as? Context & MultiPageContext,
            context.renderInitialViews(with: tokens) == true else {
                return false
        }

        window.rootViewController = context.viewController
        return true
    }

    func openModal<T>(with token: T, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        return nil
    }

    // MARK: - MultiPageContext

    func renderInitialViews<T>(with tokens: [T]) -> Bool {
        let viewControllers = tokens.compactMap { $0 as? Token }
            .compactMap { registry.createViewController(from: $0, context: self) }
            .map { UINavigationController(rootViewController: $0) }

        tabBarController.viewControllers = viewControllers
        return true
    }

    // MARK: - ForwardBackNavigationContext

    func navigateForward<T>(with token: T, animated: Bool) -> NavigationToken? {
        guard let token = token as? Token,
            let toViewController = registry.createViewController(from: token, context: self),
            let navigationController = tabBarController.selectedViewController as? UINavigationController else {
                return nil
        }

        navigationController.pushViewController(toViewController, animated: animated)
        return NavigationTokenImplementation(viewController: toViewController)
    }

    func navigateBack(animated: Bool) -> Bool {
        guard let navigationController = tabBarController.selectedViewController as? UINavigationController else {
            return false
        }
        return navigationController.popViewController(animated: animated) != nil
    }
}
