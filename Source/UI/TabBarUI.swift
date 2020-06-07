//
//  TabBarUI.swift
//  Madog
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

internal class TabBarUI<Token>: MadogModalUIContainer<Token>, MultiContext {
    private let tabBarController = UITabBarController()

    internal init?(registry: Registry<Token>, tokenData: MultiUITokenData) {
        super.init(registry: registry, viewController: tabBarController)

        guard let tokens = tokenData.tokens as? [Token] else {
            return nil
        }

        let viewControllers = tokens.compactMap { registry.createViewController(from: $0, context: self) }
            .map { UINavigationController(rootViewController: $0) }

        tabBarController.viewControllers = viewControllers
    }

    // MARK: - MultiContext

    var selectedIndex: Int {
        get { tabBarController.selectedIndex }
        set { tabBarController.selectedIndex = newValue }
    }
}
