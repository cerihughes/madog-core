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

class TabBarNavigationUITests: MadogKIFTestCase {
    private var context: TabBarNavigationUIContext!

    override func tearDown() {
        context = nil

        super.tearDown()
    }

    func testRenderInitialUI() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        XCTAssertEqual(context.selectedIndex, 0)
        XCTAssertNotNil(context)
    }

    func testNavigateForwardAndBack() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        navigateForwardAndAssert(token: "vc3", with: ["vc1", "vc2"])

        context.navigateBack(animated: true)
        assert(tokens: ["vc1", "vc2"])
    }

    func testBackToRoot() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        navigateForwardAndAssert(token: "vc3", with: ["vc1", "vc2"])
        navigateForwardAndAssert(token: "vc4", with: ["vc1", "vc2"])

        context?.navigateBackToRoot(animated: true)
        assert(token: "vc1")
    }

    func testNavigateForwardAndBack_multitab() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        navigateForwardAndAssert(token: "vc3", with: ["vc1", "vc2"])

        context.selectedIndex = 1
        viewTester().usingLabel("vc3")?.waitForAbsenceOfView()

        navigateForwardAndAssert(token: "vc4", with: ["vc1", "vc2"])

        context.navigateBack(animated: true)
        assert(tokens: ["vc1", "vc2"])
    }

    private func renderUIAndAssert(tokens: String ...) -> TabBarNavigationUIContext? {
        let identifier = MultiUIIdentifier.createTabBarNavigationIdentifier()
        let context = madog.renderUI(identifier: identifier, tokens: tokens, in: window)

        assert(tokens: tokens)

        return context as? TabBarNavigationUIContext
    }

    private func navigateForwardAndAssert(token: String, with: [String]? = nil) {
        context.navigateForward(token: token, animated: true)
        viewTester().usingLabel(token)?.waitForView()
    }
}

#endif
