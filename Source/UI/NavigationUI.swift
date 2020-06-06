//
//  NavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
internal class NavigationUI<Token>: MadogSingleUIContainer<Token> {
    private let navigationController = UINavigationController()

    internal init() {
        super.init(viewController: navigationController)
    }

    override func provideNavigationController() -> UINavigationController? {
        return navigationController
    }

    // MARK: - MadogSingleUIContainer

    override internal func renderInitialView(with token: Token) -> Bool {
        guard let viewController = registry.createViewController(from: token, context: self) else {
            return false
        }

        navigationController.setViewControllers([viewController], animated: false)
        return true
    }
}
