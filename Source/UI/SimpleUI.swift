//
//  SimpleUI.swift
//  Madog
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

internal class SimpleUI<Token>: MadogModalUIContainer<Token> {
    internal init?(registry: Registry<Token>, token: Token) {
        let fakeViewController = UIViewController()
        super.init(registry: registry, viewController: fakeViewController)

        guard let viewController = registry.createViewController(from: token, context: self) else {
            return nil
        }

        self.viewController = viewController
    }
}
