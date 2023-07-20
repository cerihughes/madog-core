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
}

class SplitUI<T>: MadogModalUIContainer<T>, SplitContext {
    private let splitController = UISplitViewController()

    init?(registry: Registry<T>, primaryToken: T, secondaryToken: T) {
        super.init(registry: registry, viewController: splitController)

        guard let primaryViewController = registry.createViewController(from: primaryToken, context: self),
            let secondaryViewController = registry.createViewController(from: secondaryToken, context: self)
        else {
            return nil
        }

        splitController.viewControllers = [primaryViewController, secondaryViewController]
    }

    // MARK: - SplitContext

    func showDetail(token: Any) -> Bool {
        guard let token = token as? T,
            let viewController = registry.createViewController(from: token, context: self)
        else {
            return false
        }

        splitController.showDetailViewController(viewController, sender: nil)
        return true
    }
}
