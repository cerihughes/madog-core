//
//  NavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class NavigationUI<Token>: NavigationContext {
    private let navigationController = UINavigationController()
    private let registry: ViewControllerRegistry<Token>
    private let factory: Factory

    init(registry: ViewControllerRegistry<Token>, factory: Factory) {
        self.registry = registry
        self.factory = factory
    }

    // MARK: - Context

    public var viewController: UIViewController {
        return navigationController
    }

    func change<T>(to ui: SinglePageUI, with token: T) -> Bool {
        if ui == .navigationController {
            return renderInitialView(with: token)
        }

        guard let window = viewController.view.window,
            let context = factory.createSinglePageUI(ui),
            context.renderInitialView(with: token) == true else {
                return false
        }

        window.rootViewController = context.viewController
        return true
    }

    func change<T>(to ui: MultiPageUI, with tokens: [T]) -> Bool {
        guard let window = viewController.view.window,
            let context = factory.createMultiPageUI(ui),
            context.renderInitialViews(with: tokens) == true else {
            return false
        }

        window.rootViewController = context.viewController
        return true
    }

    public func openModal<T>(with token: T, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        return nil
    }

    // MARK: - SinglePageContext

    func renderInitialView<T>(with token: T) -> Bool {
        guard let token = token as? Token, let viewController = registry.createViewController(from: token, context: self) else {
            return false
        }

        navigationController.setViewControllers([viewController], animated: false)
        return true
    }

    // MARK: - ForwardBackNavigationContext

    public func navigateForward<T>(with token: T, animated: Bool) -> NavigationToken? {
        guard let token = token as? Token, let viewController = registry.createViewController(from: token, context: self) else {
            return nil
        }

        navigationController.pushViewController(viewController, animated: animated)
        return NavigationTokenImplementation(viewController: viewController)
    }

    public func navigateBack(animated: Bool) -> Bool {
        return navigationController.popViewController(animated: animated) != nil
    }
}
