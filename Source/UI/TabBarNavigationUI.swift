//
//  TabBarNavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
public class TabBarNavigationUI<Token>: BaseUI {
    private let registry: ViewControllerRegistry<Token, TabBarNavigationContext>
    private let context: TabBarNavigationContextImplementation<Token>

    /// The default function by the tab bar item's tag (ascending).
    public var sortFunction: (UIViewController, UIViewController) -> Bool = { $0.tabBarItem.tag < $1.tabBarItem.tag }

    override public init() {
        self.registry = ViewControllerRegistry<Token, TabBarNavigationContext>()
        self.context = TabBarNavigationContextImplementation(registry: self.registry)

        super.init()
    }

    public func resolveInitialViewController(pageResolver: PageResolver) -> UITabBarController? {
        registerPages(with: registry, pageResolver: pageResolver)

        guard let initialViewControllers = registry.createGlobalResults(context: self.context),
            initialViewControllers.count > 0 else {
                return nil
        }

        let sortedViewControllers = initialViewControllers.sorted(by: sortFunction)
        let navigationControllers = sortedViewControllers.map { UINavigationController(rootViewController: $0) }
        self.context.tabBarController.viewControllers = navigationControllers
        return self.context.tabBarController
    }
}
