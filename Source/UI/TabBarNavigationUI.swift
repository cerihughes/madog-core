//
//  TabBarNavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
public class TabBarNavigationUI<T>: MadogNavigatingModalUIContainer<T>, MultiContext {
    private let tabBarController = UITabBarController()

    init(registry: AnyRegistry<T>, tokens: [T]) {
        super.init(registry: registry, viewController: tabBarController)

        let viewControllers = tokens
            .compactMap { registry.createViewController(from: $0, context: self) }
            .map { UINavigationController(rootViewController: $0) }

        tabBarController.viewControllers = viewControllers
    }

    override public func provideNavigationController() -> UINavigationController? {
        tabBarController.selectedViewController as? UINavigationController
    }

    // MARK: - MultiContext

    public var selectedIndex: Int {
        get { tabBarController.selectedIndex }
        set { tabBarController.selectedIndex = newValue }
    }
}
