//
//  TabBarNavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class TabBarNavigationUI<Token>: MultiPageContextUI, TabBarNavigationContext {
    private let tabBarController = UITabBarController()
    private let registry: ViewControllerRegistry<Token>
    private let factory: Factory

    weak var delegate: ContextUIDelegate?

    init(registry: ViewControllerRegistry<Token>, factory: Factory) {
        self.registry = registry
        self.factory = factory
    }

    deinit {
        print("TabBarNavigationUI deinit")
    }

    // MARK: - Context

    var viewController: UIViewController {
        return tabBarController
    }

    func change<Token>(to uiIdentifier: SinglePageUIIdentifier, with token: Token) -> Bool {
        guard let delegate = delegate, let window = viewController.view.window else {
            return false
        }

        return delegate.renderSinglePageUI(uiIdentifier, with: token, in: window)
    }

    func change<Token>(to uiIdentifier: MultiPageUIIdentifier, with tokens: [Token]) -> Bool {
        guard let delegate = delegate, let window = viewController.view.window else {
            return false
        }

        return delegate.renderMultiPageUI(uiIdentifier, with: tokens, in: window)
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
