//
//  TabBarNavigationUITests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class TabBarNavigationUITests: KIFTestCase {
    private var window: UIWindow!
    private var madog: Madog<String>!
    private var context: NavigationModalMultiContext!

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
        context = renderUIAndAssert(tokens: ["vc1", "vc2"])
        XCTAssertEqual(context.selectedIndex, 0)
        XCTAssertNotNil(context)
    }

    func testNavigateForwardAndBack() {
        context = renderUIAndAssert(tokens: ["vc1", "vc2"])
        navigateForwardAndAssert(token: "vc3", with: ["vc1", "vc2"])

        context.navigateBack(animated: true)
        assert(tokens: ["vc1", "vc2"])
    }

    func testBackToRoot() {
        context = renderUIAndAssert(tokens: ["vc1", "vc2"])
        navigateForwardAndAssert(token: "vc3", with: ["vc1", "vc2"])
        navigateForwardAndAssert(token: "vc4", with: ["vc1", "vc2"])

        context?.navigateBackToRoot(animated: true)
        assert(token: "vc1")
    }

    func testNavigateForwardAndBack_multitab() {
        context = renderUIAndAssert(tokens: ["vc1", "vc2"])
        navigateForwardAndAssert(token: "vc3", with: ["vc1", "vc2"])

        context.selectedIndex = 1
        viewTester().usingLabel("vc3")?.waitForAbsenceOfView()

        navigateForwardAndAssert(token: "vc4", with: ["vc1", "vc2"])

        context.navigateBack(animated: true)
        assert(tokens: ["vc1", "vc2"])
    }

    private func renderUIAndAssert(tokens: [String]) -> NavigationModalMultiContext? {
        let identifier = MultiUIIdentifier.createTabBarNavigationIdentifier()
        let context = madog.renderUI(identifier: identifier, tokens: tokens, in: window)

        assert(tokens: tokens)

        return context as? NavigationModalMultiContext
    }

    private func assert(token: String) {
        assert(tokens: [token])
    }

    private func assert(tokens: [String]) {
        tokens.forEach {
            viewTester().usingLabel($0)?.waitForView()
        }
    }

    private func navigateForwardAndAssert(token: String, with: [String]? = nil) {
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
