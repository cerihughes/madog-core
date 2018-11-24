//
//  NavigationContextImplementation.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal class NavigationContextImplementation<Token>: ModalContextImplementation, NavigationContext {
    internal let navigationController = UINavigationController()
    private let registry: ViewControllerRegistry<Token, NavigationContext>

    internal init(registry: ViewControllerRegistry<Token, NavigationContext>) {
        self.registry = registry

        super.init(viewController: self.navigationController)
    }

    // MARK: NavigationContext

    public func navigateForward<ContextToken>(with token: ContextToken, animated: Bool) -> NavigationToken? {
        guard let token = token as? Token, let viewController = registry.createResult(from: token, context: self) else {
            return nil
        }

        navigationController.pushViewController(viewController, animated: animated)
        return NavigationTokenImplementation(viewController: viewController)
    }

    public func navigateBack(animated: Bool) -> Bool {
        return navigationController.popViewController(animated: animated) != nil
    }
}
