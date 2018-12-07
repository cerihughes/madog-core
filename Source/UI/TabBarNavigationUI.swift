//
//  TabBarNavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol TabBarNavigationContext: class, Context, MultiPageContext, ForwardBackNavigationContext {}

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
internal class TabBarNavigationUI: MadogUIContext, TabBarNavigationContext {
    private let tabBarController = UITabBarController()
    private let registry: ViewControllerRegistry
    private let factory: MadogUIContextFactory

    internal weak var delegate: MadogUIContextDelegate?

    internal init(registry: ViewControllerRegistry, factory: MadogUIContextFactory) {
        self.registry = registry
        self.factory = factory
    }

    deinit {
        print("TabBarNavigationUI deinit")
    }

    // MARK: - Context

    internal var viewController: UIViewController {
        return tabBarController
    }

    internal func change<T>(to uiIdentifier: SinglePageUIIdentifier, with token: T) -> Bool {
        guard let delegate = delegate, let window = viewController.view.window else {
            return false
        }

        return delegate.renderSinglePageUI(uiIdentifier, with: token, in: window)
    }

    internal func change<T>(to uiIdentifier: MultiPageUIIdentifier, with tokens: [T]) -> Bool {
        guard let delegate = delegate, let window = viewController.view.window else {
            return false
        }

        return delegate.renderMultiPageUI(uiIdentifier, with: tokens, in: window)
    }

    internal func openModal<T>(with token: T, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        return nil
    }

    // MARK: - MultiPageContext

    internal func renderInitialViews(with tokens: [Any]) -> Bool {
        let viewControllers = tokens.compactMap { registry.createViewController(from: $0, context: self) }
            .map { UINavigationController(rootViewController: $0) }

        tabBarController.viewControllers = viewControllers
        return true
    }

    // MARK: - ForwardBackNavigationContext

    internal func navigateForward(with token: Any, animated: Bool) -> NavigationToken? {
        guard let toViewController = registry.createViewController(from: token, context: self),
            let navigationController = tabBarController.selectedViewController as? UINavigationController else {
                return nil
        }

        navigationController.pushViewController(toViewController, animated: animated)
        return NavigationTokenImplementation(viewController: toViewController)
    }

    internal func navigateBack(animated: Bool) -> Bool {
        guard let navigationController = tabBarController.selectedViewController as? UINavigationController else {
            return false
        }

        return navigationController.popViewController(animated: animated) != nil
    }
}
