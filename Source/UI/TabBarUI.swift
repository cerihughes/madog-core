//
//  TabBarUI.swift
//  Madog
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

public class TabBarUI<T>: MadogModalUIContainer<T>, MultiContext {
    private let tabBarController = UITabBarController()

    init(registry: AnyRegistry<T>, tokens: [T]) {
        super.init(registry: registry, viewController: tabBarController)

        let viewControllers = tokens.compactMap { registry.createViewController(from: $0, context: self) }

        tabBarController.viewControllers = viewControllers
    }

    // MARK: - MultiContext

    public var selectedIndex: Int {
        get { tabBarController.selectedIndex }
        set { tabBarController.selectedIndex = newValue }
    }
}
