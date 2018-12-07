//
//  NavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

protocol NavigationContext: class, Context, SinglePageContext, ForwardBackNavigationContext {}

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class NavigationUI: SinglePageUIContext, NavigationContext {
    private let navigationController = UINavigationController()
    private let registry: ViewControllerRegistry
    private let factory: MadogUIContextFactory

    weak var delegate: MadogUIContextDelegate?

    init(registry: ViewControllerRegistry, factory: MadogUIContextFactory) {
        self.registry = registry
        self.factory = factory
    }

    deinit {
        print("NavigationUI deinit")
    }

    // MARK: - Context

    public var viewController: UIViewController {
        return navigationController
    }

    func change(to uiIdentifier: SinglePageUIIdentifier, with token: Any) -> Bool {
        guard let delegate = delegate, let window = viewController.view.window else {
            return false
        }

        return delegate.renderSinglePageUI(uiIdentifier, with: token, in: window)
    }

    func change(to uiIdentifier: MultiPageUIIdentifier, with tokens: [Any]) -> Bool {
        guard let delegate = delegate, let window = viewController.view.window else {
            return false
        }

        return delegate.renderMultiPageUI(uiIdentifier, with: tokens, in: window)
    }

    public func openModal(with token: Any, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        return nil
    }

    // MARK: - SinglePageContext

    func renderInitialView(with token: Any) -> Bool {
        guard let viewController = registry.createViewController(from: token, context: self) else {
            return false
        }

        navigationController.setViewControllers([viewController], animated: false)
        return true
    }

    // MARK: - ForwardBackNavigationContext

    public func navigateForward(with token: Any, animated: Bool) -> NavigationToken? {
        guard let viewController = registry.createViewController(from: token, context: self) else {
            return nil
        }

        navigationController.pushViewController(viewController, animated: animated)
        return NavigationTokenImplementation(viewController: viewController)
    }

    public func navigateBack(animated: Bool) -> Bool {
        return navigationController.popViewController(animated: animated) != nil
    }
}
