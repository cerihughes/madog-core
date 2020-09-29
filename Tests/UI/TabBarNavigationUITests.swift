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

        navigateForwardAndAssert(token: "vc3")
        viewTester().waitForAbsenceOfLabel(token: "vc1")

        context.navigateBack(animated: true)
        viewTester().waitForAbsenceOfLabel(token: "vc3")
        viewTester().waitForLabel(token: "vc1")
    }

    func testBackToRoot() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        
        navigateForwardAndAssert(token: "vc3")
        viewTester().waitForAbsenceOfLabel(token: "vc1")
        
        navigateForwardAndAssert(token: "vc4")
        viewTester().waitForAbsenceOfLabel(token: "vc3")

        context?.navigateBackToRoot(animated: true)
        viewTester().waitForAbsenceOfLabel(token: "vc4")
        viewTester().waitForLabel(token: "vc1")
    }

    func testNavigateForwardAndBack_multitab() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        navigateForwardAndAssert(token: "vc3")

        context.selectedIndex = 1
        viewTester().waitForAbsenceOfLabel(token: "vc3")
        viewTester().waitForLabel(token: "vc2")

        navigateForwardAndAssert(token: "vc4")
        viewTester().waitForAbsenceOfLabel(token: "vc2")
        viewTester().waitForLabel(token: "vc4")

        context.navigateBack(animated: true)
        viewTester().waitForAbsenceOfLabel(token: "vc4")
        viewTester().waitForLabel(token: "vc2")
    }

    func testOpenMultiNavigationModal() {
        let context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? ModalContext
        viewTester().waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        let modalToken = context!.openModal(identifier: .tabBarNavigation,
                                            tokenData: .multi(["vc2", "vc3"]),
                                            presentationStyle: .formSheet,
                                            animated: true)
        viewTester().waitForTitle(token: "vc2")
        viewTester().waitForLabel(token: "vc2")
        viewTester().waitForTitle(token: "vc3")
        viewTester().waitForAbsenceOfLabel(token: "vc3")

        var modalContext = modalToken?.context as? TabBarNavigationUIContext
        XCTAssertNotNil(modalContext)

        modalContext?.navigateForward(token: "vc4", animated: true)
        viewTester().waitForTitle(token: "vc4")
        viewTester().waitForLabel(token: "vc4")

        modalContext?.navigateForward(token: "vc5", animated: true)
        modalContext?.navigateForward(token: "vc6", animated: true)
        viewTester().waitForAbsenceOfTitle(token: "vc4") // "Back" no longer shows "vc4"
        viewTester().waitForTitle(token: "vc5") // "Back" shows "vc5"
        viewTester().waitForTitle(token: "vc6")
        viewTester().waitForLabel(token: "vc6")

        modalContext?.selectedIndex = 1
        modalContext?.navigateForward(token: "vc7", animated: true)
        viewTester().waitForTitle(token: "vc3") // "Back" shows "vc3"
        viewTester().waitForTitle(token: "vc7")
        viewTester().waitForLabel(token: "vc7")

        modalContext?.navigateForward(token: "vc8", animated: true)
        modalContext?.navigateForward(token: "vc9", animated: true)
        viewTester().waitForAbsenceOfTitle(token: "vc7") // "Back" no longer shows "vc7"
        viewTester().waitForTitle(token: "vc8") // "Back" shows "vc8"
        viewTester().waitForTitle(token: "vc9")
        viewTester().waitForLabel(token: "vc9")

        modalContext?.selectedIndex = 0
        viewTester().waitForAbsenceOfTitle(token: "vc8") // "Back" no longer shows "vc8"
        viewTester().waitForTitle(token: "vc5") // "Back" shows "vc5"
        viewTester().waitForTitle(token: "vc6")
        viewTester().waitForLabel(token: "vc6")
    }

    private func renderUIAndAssert(tokens: String ...) -> TabBarNavigationUIContext? {
        let context = madog.renderUI(identifier: .tabBarNavigation, tokenData: .multi(tokens), in: window)
        tokens.forEach { viewTester().waitForTitle(token: $0) }
        viewTester().waitForLabel(token: tokens.first!)
        return context as? TabBarNavigationUIContext
    }

    private func navigateForwardAndAssert(token: String) {
        context.navigateForward(token: token, animated: true)
        viewTester().waitForLabel(token: token)
    }
}

#endif
