//
//  NavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol NavigationContext: Context, ForwardBackNavigationContext {}

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
internal class NavigationUI<Token>: MadogSinglePageUIContext<Token>, NavigationContext {
    private let navigationController = UINavigationController()

    internal init() {
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

    // MARK: - ForwardBackNavigationContext

    internal func navigateForward(with token: Any, animated: Bool) -> NavigationToken? {
        guard let viewController = registry.createViewController(from: token, context: self) else {
            return nil
        }

        navigationController.pushViewController(viewController, animated: animated)
        return createNavigationToken(for: viewController)
    }

    internal func navigateBack(animated: Bool) -> Bool {
        return navigationController.popViewController(animated: animated) != nil
    }
}
