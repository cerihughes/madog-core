//
//  ModalContextImplementation.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal class ModalContextImplementation: Context {
    internal let viewController: UIViewController

    internal init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func openModal<Token>(with token: Token, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        return nil
    }
}
