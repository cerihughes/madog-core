//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF) && canImport(UIKit)

import KIF
import XCTest
import UIKit

@testable import MadogCore

open class MadogKIFTestCase: KIFTestCase, MadogCUT {
    public var window: UIWindow!
    public var madog: Madog<String>!

    open override func beforeEach() {
        super.beforeEach()

        window = UIWindow()
        window.makeKeyAndVisible()
        madog = Madog()
        madog.resolve(resolver: KIFTestResolver())
        madog.registerTestContainers()
    }

    open override func afterEach() {
        window.rootViewController = nil
        window = nil
        madog = nil

        super.afterEach()
    }
}

private class KIFTestResolver: Resolver {
    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<String>] {
        [KIFTestViewControllerProvider.init]
    }
}

private class KIFTestViewControllerProvider: ViewControllerProvider {
    func createViewController(token: String, container: AnyContainer<String>) -> UIViewController? {
        let viewController = KIFTestViewController()
        viewController.title = token.viewControllerTitle
        viewController.label.text = token.viewControllerLabel
        return viewController
    }
}

private class KIFTestViewController: UIViewController {
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        label.textColor = .darkGray

        view.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

#endif
