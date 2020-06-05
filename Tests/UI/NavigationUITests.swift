//
//  NavigationUITests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class NavigationUITests: KIFTestCase {
    private var window: UIWindow!
    private var madog: Madog<String>!
    private var context: NavigationModalContext!

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

    func testRenderInitialUI() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNotNil(context)
    }

    func testNavigateForwardAndBack() {
        context = renderUIAndAssert(token: "vc1")
        navigateForwardAndAssert(token: "vc2")

        context.navigateBack(animated: true)
        viewTester().usingLabel("vc1")?.waitForView()
    }

    func testBackToRoot() {
        context = renderUIAndAssert(token: "vc1")
        navigateForwardAndAssert(token: "vc2")
        navigateForwardAndAssert(token: "vc3")

        context?.navigateBackToRoot(animated: true)
        viewTester().usingLabel("vc1")?.waitForView()
    }

    private func renderUIAndAssert(token: String) -> NavigationModalContext? {
        let identifier = SingleUIIdentifier.createNavigationIdentifier()
        let context = madog.renderUI(identifier: identifier, token: token, in: window)
        viewTester().usingLabel(token)?.waitForView()
        return context as? NavigationModalContext
    }

    private func navigateForwardAndAssert(token: String) {
        context.navigateForward(token: token, animated: true)
        viewTester().usingLabel(token)?.waitForView()
    }
}

private class TestResolver: Resolver<String> {
    override func viewControllerProviderFunctions() -> [() -> ViewControllerProvider<String>] {
        [TestViewControllerProvider.init]
    }
}

private class TestViewControllerProvider: BaseViewControllerProvider {
    override func createViewController(token: String, context: Context) -> UIViewController? {
        let viewController = UIViewController()
        viewController.title = token
        return viewController
    }
}

#endif
