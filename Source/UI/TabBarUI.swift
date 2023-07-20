//
//  TabBarUI.swift
//  Madog
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

internal class TabBarUI<T>: MadogModalUIContainer<T>, MultiContext {
    private let tabBarController = UITabBarController()

    internal init(registry: Registry<T>, tokens: [T]) {
        super.init(registry: registry, viewController: tabBarController)

        let viewControllers = tokens.compactMap { registry.createViewController(from: $0, context: self) }

        tabBarController.viewControllers = viewControllers
    }

    // MARK: - MultiContext

    var selectedIndex: Int {
        get { tabBarController.selectedIndex }
        set { tabBarController.selectedIndex = newValue }
    }
}
