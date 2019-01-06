//
//  SplitUI.swift
//  MadogSample
//
//  Created by Ceri Hughes on 11/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

protocol SplitContext: Context, ForwardBackNavigationContext {}

class SplitUI<Token>: MadogSingleUIContext<Token>, SplitContext {
    private let splitController = UISplitViewController()

    init() {
        super.init(viewController: splitController)
    }

    // MARK: - MadogSingleUIContext

    override func renderInitialView(with token: Token) -> Bool {
        guard let viewController = registry.createViewController(from: token, context: self) else {
            return false
        }

        splitController.viewControllers = [viewController]
        return true
    }

    // MARK: - ForwardBackNavigationContext

    func navigateForward(token: Any, animated: Bool) -> NavigationToken? {
        guard let viewController = registry.createViewController(from: token, context: self) else {
            return nil
        }

        splitController.showDetailViewController(viewController, sender: splitController.viewControllers.first)
        return createNavigationToken(for: viewController)
    }

    func navigateBack(animated: Bool) -> Bool {
        guard let first = splitController.viewControllers.first else {
            return false
        }
        splitController.viewControllers = [first]
        return true
    }

    func navigateBackToRoot(animated: Bool) -> Bool {
        return navigateBack(animated: animated)
    }
}
