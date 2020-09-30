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

    override func afterEach() {
        context = nil

        super.afterEach()
    }

    func testRenderInitialUI() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        XCTAssertEqual(context.selectedIndex, 0)
        XCTAssertNotNil(context)
    }

    func testNavigateForwardAndBack() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")

        navigateForwardAndAssert(token: "vc3")
        waitForAbsenceOfLabel(token: "vc1")

        context.navigateBack(animated: true)
        waitForAbsenceOfLabel(token: "vc3")
        waitForLabel(token: "vc1")
    }

    func testBackToRoot() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        
        navigateForwardAndAssert(token: "vc3")
        waitForAbsenceOfLabel(token: "vc1")
        
        navigateForwardAndAssert(token: "vc4")
        waitForAbsenceOfLabel(token: "vc3")

        context?.navigateBackToRoot(animated: true)
        waitForAbsenceOfLabel(token: "vc4")
        waitForLabel(token: "vc1")
    }

    func testNavigateForwardAndBack_multitab() {
        context = renderUIAndAssert(tokens: "vc1", "vc2")
        navigateForwardAndAssert(token: "vc3")

        context.selectedIndex = 1
        waitForAbsenceOfLabel(token: "vc3")
        waitForLabel(token: "vc2")

        navigateForwardAndAssert(token: "vc4")
        waitForAbsenceOfLabel(token: "vc2")
        waitForLabel(token: "vc4")

        context.navigateBack(animated: true)
        waitForAbsenceOfLabel(token: "vc4")
        waitForLabel(token: "vc2")
    }

    func testOpenMultiNavigationModal() {
        let context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? ModalContext
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        let modalToken = context!.openModal(identifier: .tabBarNavigation,
                                            tokenData: .multi(["vc2", "vc3"]),
                                            presentationStyle: .formSheet,
                                            animated: true)
        waitForTitle(token: "vc2")
        waitForLabel(token: "vc2")
        waitForTitle(token: "vc3")
        waitForAbsenceOfLabel(token: "vc3")

        var modalContext = modalToken?.context as? TabBarNavigationUIContext
        XCTAssertNotNil(modalContext)

        modalContext?.navigateForward(token: "vc4", animated: true)
        waitForTitle(token: "vc4")
        waitForLabel(token: "vc4")

        modalContext?.navigateForward(token: "vc5", animated: true)
        modalContext?.navigateForward(token: "vc6", animated: true)
        waitForAbsenceOfTitle(token: "vc4") // "Back" no longer shows "vc4"
        waitForTitle(token: "vc5") // "Back" shows "vc5"
        waitForTitle(token: "vc6")
        waitForLabel(token: "vc6")

        modalContext?.selectedIndex = 1
        modalContext?.navigateForward(token: "vc7", animated: true)
        waitForTitle(token: "vc3") // "Back" shows "vc3"
        waitForTitle(token: "vc7")
        waitForLabel(token: "vc7")

        modalContext?.navigateForward(token: "vc8", animated: true)
        modalContext?.navigateForward(token: "vc9", animated: true)
        waitForAbsenceOfTitle(token: "vc7") // "Back" no longer shows "vc7"
        waitForTitle(token: "vc8") // "Back" shows "vc8"
        waitForTitle(token: "vc9")
        waitForLabel(token: "vc9")

        modalContext?.selectedIndex = 0
        waitForAbsenceOfTitle(token: "vc8") // "Back" no longer shows "vc8"
        waitForTitle(token: "vc5") // "Back" shows "vc5"
        waitForTitle(token: "vc6")
        waitForLabel(token: "vc6")
    }

    private func renderUIAndAssert(tokens: String ...) -> TabBarNavigationUIContext? {
        let context = madog.renderUI(identifier: .tabBarNavigation, tokenData: .multi(tokens), in: window)
        tokens.forEach { waitForTitle(token: $0) }
        waitForLabel(token: tokens.first!)
        return context as? TabBarNavigationUIContext
    }

    private func navigateForwardAndAssert(token: String) {
        context.navigateForward(token: token, animated: true)
        waitForLabel(token: token)
    }
}

#endif
