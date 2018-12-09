//
//  NavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol NavigationContext: class, Context, ModalContext, ForwardBackNavigationContext {}

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
internal class NavigationUI<Token>: MadogSinglePageUIContext<Token>, NavigationContext {
    private let navigationController = UINavigationController()
    private let registry: ViewControllerRegistry
    private let factory: MadogUIContextFactory<Token>

    internal init(registry: ViewControllerRegistry, factory: MadogUIContextFactory<Token>) {
        self.registry = registry
        self.factory = factory
        super.init(viewController: navigationController)
    }

    // MARK: - MadogSinglePageUIContext

    override internal func renderInitialView(with token: Token) -> Bool {
        guard let viewController = registry.createViewController(from: token, context: self) else {
            return false
        }

        navigationController.setViewControllers([viewController], animated: false)
        return true
    }

    // MARK: - Context

    internal func change<VC: UIViewController>(to uiIdentifier: SinglePageUIIdentifier<VC>, with token: Any) -> Bool {
        guard let delegate = delegate, let window = viewController.view.window else {
            return false
        }

        return delegate.renderSinglePageUI(uiIdentifier, with: token, in: window)
    }

    internal func change<VC: UIViewController>(to uiIdentifier: MultiPageUIIdentifier<VC>, with tokens: [Any]) -> Bool {
        guard let delegate = delegate, let window = viewController.view.window else {
            return false
        }

        return delegate.renderMultiPageUI(uiIdentifier, with: tokens, in: window)
    }

    internal func openModal(with token: Any, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        return nil
    }

    // MARK: - ForwardBackNavigationContext

    internal func navigateForward(with token: Any, animated: Bool) -> NavigationToken? {
        guard let viewController = registry.createViewController(from: token, context: self) else {
            return nil
        }

        navigationController.pushViewController(viewController, animated: animated)
        return NavigationTokenImplementation(viewController: viewController)
    }

    internal func navigateBack(animated: Bool) -> Bool {
        return navigationController.popViewController(animated: animated) != nil
    }
}
