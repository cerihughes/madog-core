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

class NavigationUITests: MadogKIFTestCase {
    private var context: NavigationUIContext!

    override func tearDown() {
        context = nil

        super.tearDown()
    }

    func testProtocolConformance() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNil(context as? MultiContext)
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

    private func renderUIAndAssert(token: String) -> NavigationUIContext? {
        let context = madog.renderUI(identifier: .navigation, tokenData: token.singleTokenData, in: window)
        viewTester().usingLabel(token)?.waitForView()
        return context as? NavigationUIContext
    }

    private func navigateForwardAndAssert(token: String) {
        context.navigateForward(token: token, animated: true)
        viewTester().usingLabel(token)?.waitForView()
    }
}

#endif
