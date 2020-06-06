//
//  SplitUI.swift
//  MadogSample
//
//  Created by Ceri Hughes on 11/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

protocol SplitContext: Context {
    @discardableResult
    func showDetail(token: Any) -> Bool

    @discardableResult
    func removeDetail() -> Bool
}

class SplitUI<Token>: MadogModalUIContainer<Token>, SplitContext {
    private let splitController = UISplitViewController()

    init?(registry: Registry<Token>, token: Token) {
        super.init(registry: registry, viewController: splitController)

        guard let viewController = registry.createViewController(from: token, context: self) else {
            return nil
        }

        splitController.viewControllers = [viewController]
    }

    // MARK: - SplitContext

    func showDetail(token: Any) -> Bool {
        guard let token = token as? Token,
            let viewController = registry.createViewController(from: token, context: self) else {
            return false
        }

        splitController.showDetailViewController(viewController, sender: splitController.viewControllers.first)
        return true
    }

    func removeDetail() -> Bool {
        guard let first = splitController.viewControllers.first else {
            return false
        }
        splitController.viewControllers = [first]
        return true
    }
}
