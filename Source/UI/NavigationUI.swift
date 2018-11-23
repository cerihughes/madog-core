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
public class NavigationUI<Token>: BaseUI<Token, NavigationContext> {
    private let context: NavigationContextImplementation<Token>

    public init?(pageResolver: PageResolver) {
        let registry = ViewControllerRegistry<Token, NavigationContext>()
        self.context = NavigationContextImplementation(registry: registry)

        super.init(pageResolver: pageResolver, registry: registry)

        guard let initialViewControllers = registry.createGlobalResults(context: self.context),
            let initialViewController = initialViewControllers.first else {
            return nil
        }

        if initialViewControllers.count > 1 {
            print("Warning: More than 1 initial registry function is registered. There are no guarantees about which will be used.")
        }

        self.context.navigationController.pushViewController(initialViewController, animated: false)
    }

    public var initialViewController: UINavigationController {
        return self.context.navigationController
    }
}
