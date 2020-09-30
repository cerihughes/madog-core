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

    override func afterEach() {
        context = nil

        super.afterEach()
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
        viewTester().waitForLabel(token: "vc1")
        viewTester().waitForAbsenceOfTitle(token: "vc2")
    }

    func testBackToRoot() {
        context = renderUIAndAssert(token: "vc1")

        navigateForwardAndAssert(token: "vc2")
        viewTester().waitForAbsenceOfLabel(token: "vc1")

        navigateForwardAndAssert(token: "vc3")
        viewTester().waitForAbsenceOfLabel(token: "vc2")
        viewTester().waitForAbsenceOfTitle(token: "vc1") // "Back" no longer shows "vc1"

        context?.navigateBackToRoot(animated: true)
        viewTester().waitForTitle(token: "vc1")
        viewTester().waitForLabel(token: "vc1")
    }

    func testOpenNavigationModal() {
        context = renderUIAndAssert(token: "vc1")

        let modalToken = context.openModal(identifier: .navigation,
                                           tokenData: .single("vc2"),
                                           presentationStyle: .formSheet,
                                           animated: true)
        viewTester().waitForTitle(token: "vc2")
        viewTester().waitForLabel(token: "vc2")

        let modalContext = modalToken?.context as? ForwardBackNavigationContext
        XCTAssertNotNil(modalContext)

        modalContext?.navigateForward(token: "vc3", animated: true)
        viewTester().waitForTitle(token: "vc3")
        viewTester().waitForLabel(token: "vc3")
        viewTester().waitForAbsenceOfLabel(token: "vc2")

        modalContext?.navigateForward(token: "vc4", animated: true)
        viewTester().waitForTitle(token: "vc4")
        viewTester().waitForLabel(token: "vc4")
        viewTester().waitForAbsenceOfTitle(token: "vc2") // "Back" no longer shows "vc2"
    }

    private func renderUIAndAssert(token: String) -> NavigationUIContext? {
        let context = madog.renderUI(identifier: .navigation, tokenData: .single(token), in: window)
        viewTester().waitForTitle(token: token)
        viewTester().waitForLabel(token: token)
        return context as? NavigationUIContext
    }

    private func navigateForwardAndAssert(token: String) {
        context.navigateForward(token: token, animated: true)
        viewTester().waitForTitle(token: token)
        viewTester().waitForLabel(token: token)
    }
}

#endif
