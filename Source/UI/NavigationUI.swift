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
class NavigationUI<T>: MadogNavigatingModalUIContainer<T> {
    private let navigationController = UINavigationController()

    init?(registry: AnyRegistry<T>, token: T) {
        super.init(registry: registry, viewController: navigationController)

        guard let viewController = registry.createViewController(from: token, context: self) else { return nil }
        navigationController.setViewControllers([viewController], animated: false)
    }

    override func provideNavigationController() -> UINavigationController? {
        navigationController
    }
}
