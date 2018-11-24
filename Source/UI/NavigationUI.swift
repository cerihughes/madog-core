//
//  NavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
public class NavigationUI<Token>: BaseUI {
    private let registry: ViewControllerRegistry<Token, NavigationContext>
    private let context: NavigationContextImplementation<Token>

    override public init() {
        self.registry = ViewControllerRegistry<Token, NavigationContext>()
        self.context = NavigationContextImplementation(registry: self.registry)

        super.init()
    }

    deinit {
        unregisterPages(from: self.registry)
    }

    public func resolveInitialViewController(pageResolver: PageResolver) -> UINavigationController? {
        registerPages(with: registry, pageResolver: pageResolver)
        
        guard let initialViewControllers = registry.createGlobalResults(context: self.context),
            let initialViewController = initialViewControllers.first else {
                return nil
        }

        if initialViewControllers.count > 1 {
            print("Warning: More than 1 initial registry function is registered. There are no guarantees about which will be used.")
        }

        self.context.navigationController.pushViewController(initialViewController, animated: false)
        return self.context.navigationController
    }
}
