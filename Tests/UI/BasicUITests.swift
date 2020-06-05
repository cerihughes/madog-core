//
//  BasicUITests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class BasicUITests: KIFTestCase {
    private var window: UIWindow!
    private var madog: Madog<String>!
    private var context: BasicUIContext!

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
        context = nil

        super.tearDown()
    }

    func testProtocolConformance() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNil(context as? ForwardBackNavigationContext)
        XCTAssertNil(context as? MultiContext)
    }

    func testRenderInitialUI() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNotNil(context)
    }

    private func renderUIAndAssert(token: String) -> BasicUIContext? {
        let identifier = SingleUIIdentifier.createBasicIdentifier()
        let context = madog.renderUI(identifier: identifier, token: token, in: window)
        viewTester().usingLabel(token)?.waitForView()
        return context as? BasicUIContext
    }
}

private class TestResolver: Resolver<String> {
    override func viewControllerProviderFunctions() -> [() -> ViewControllerProvider<String>] {
        [TestViewControllerProvider.init]
    }
}

private class TestViewControllerProvider: BaseViewControllerProvider {
    override func createViewController(token: String, context: Context) -> UIViewController? {
        let label = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 100)))
        label.text = token
        let viewController = UIViewController()
        viewController.view.addSubview(label)
        return viewController
    }
}

#endif
