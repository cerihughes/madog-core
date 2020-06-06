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

class SplitUI<Token>: MadogSingleUIContainer<Token>, SplitContext {
    private let splitController = UISplitViewController()

    init() {
        super.init(viewController: splitController)
    }

    // MARK: - MadogSingleUIContainer

    override func renderInitialView(with token: Token) -> Bool {
        guard let viewController = registry.createViewController(from: token, context: self) else {
            return false
        }

        splitController.viewControllers = [viewController]
        return true
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
