//
//  MadogKIFTestCase.swift
//  MadogTests
//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class MadogKIFTestCase: KIFTestCase {
    var window: UIWindow!
    var madog: Madog<String>!

    override func setUp() {
        super.setUp()

        window = UIWindow()
        window.makeKeyAndVisible()
        madog = Madog()
        madog.resolve(resolver: TestResolver())
    }

    override func tearDown() {
        window.rootViewController = nil
        window = nil
        madog = nil

        super.tearDown()
    }

    func assert(token: String) {
        assert(tokens: [token])
    }

    func assert(tokens: [String]) {
        tokens.forEach {
            viewTester().usingLabel($0)?.waitForView()
        }
    }
}

private class TestResolver: Resolver<String> {
    override func viewControllerProviderFunctions() -> [() -> ViewControllerProvider<String>] {
        [TestViewControllerProvider.init]
    }
}

private class TestViewControllerProvider: BaseViewControllerProvider {
    override func createViewController(token: String, context _: Context) -> UIViewController? {
        let viewController = TestViewController()
        viewController.title = token
        viewController.label.text = "Label: \(token)"
        return viewController
    }
}

private class TestViewController: UIViewController {
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        label.textColor = .white

        view.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

#endif
