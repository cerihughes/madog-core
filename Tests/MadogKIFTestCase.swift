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
        window = nil
        madog = nil

        super.tearDown()
    }
}

private class TestResolver: Resolver<String> {
    override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<String>] {
        return [
            { TestViewControllerProvider() }
        ]
    }
}

private class TestViewControllerProvider: BaseViewControllerProvider {
    override func createViewController(token: String, context _: Context) -> UIViewController? {
        let viewController = TestViewController()
        viewController.title = token
        viewController.label.text = token
        return viewController
    }
}

private class TestViewController: UIViewController {
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
    }
}

#endif
