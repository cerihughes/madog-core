//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import KIF
import XCTest

@testable import MadogCore

class MadogKIFTestCase: KIFTestCase, MadogCUT {
    var window: UIWindow!
    var madog: Madog<String>!

    override func beforeEach() {
        super.beforeEach()

        window = UIWindow()
        window.makeKeyAndVisible()
        madog = Madog()
        madog.resolve(resolver: TestResolver())
        madog.registerDefaultContainers()
    }

    override func afterEach() {
        window.rootViewController = nil
        window = nil
        madog = nil

        super.afterEach()
    }
}

private class TestResolver: Resolver {
    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<String>] {
        [TestViewControllerProvider.init]
    }
}

private class TestViewControllerProvider: ViewControllerProvider {
    func createViewController(token: String, context: AnyContext<String>) -> UIViewController? {
        let viewController = TestViewController()
        viewController.title = token.viewControllerTitle
        viewController.label.text = token.viewControllerLabel
        return viewController
    }
}

private class TestViewController: UIViewController {
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
