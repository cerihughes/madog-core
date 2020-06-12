//
//  BasicUI.swift
//  Madog
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

internal class BasicUI<Token>: MadogModalUIContainer<Token> {
    private let containerController = BasicUIContainerViewController()

    internal init?(registry: Registry<Token>, token: Token) {
        super.init(registry: registry, viewController: containerController)

        guard let viewController = registry.createViewController(from: token, context: self) else {
            return nil
        }

        containerController.contentViewController = viewController
    }
}

open class BasicUIContainerViewController: UIViewController {
    deinit {
        contentViewController = nil
    }

    var contentViewController: UIViewController? {
        didSet {
            removeContentViewController(oldValue)
            addContentViewController(contentViewController)
        }
    }

    private func removeContentViewController(_ viewController: UIViewController?) {
        if let viewController = viewController {
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParent()
        }
    }

    private func addContentViewController(_ viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }

        viewController.willMove(toParent: self)

        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewController.didMove(toParent: self)
    }
}
