//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class NavigationUITests: MadogKIFTestCase {
    private var context: AnyNavigationUIContext<String>!

    override func afterEach() {
        context = nil
        super.afterEach()
    }

    func testProtocolConformance() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNil(context as? AnyMultiContext<String>)
    }

    func testRenderInitialUI() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNotNil(context)
    }

    func testNavigateForwardAndBack() {
        context = renderUIAndAssert(token: "vc1")
        navigateForwardAndAssert(token: "vc2")

        context.navigateBack(animated: true)
        waitForLabel(token: "vc1")
        waitForAbsenceOfTitle(token: "vc2")
    }

    func testBackToRoot() {
        context = renderUIAndAssert(token: "vc1")

        navigateForwardAndAssert(token: "vc2")
        waitForAbsenceOfLabel(token: "vc1")

        navigateForwardAndAssert(token: "vc3")
        waitForAbsenceOfLabel(token: "vc2")
        waitForAbsenceOfTitle(token: "vc1") // "Back" no longer shows "vc1"

        context?.navigateBackToRoot(animated: true)
        waitForTitle(token: "vc1")
        waitForLabel(token: "vc1")
    }

    func testOpenNavigationModal() {
        context = renderUIAndAssert(token: "vc1")

        let modalToken = context.openModal(
            identifier: .navigation(),
            tokenData: .single("vc2"),
            presentationStyle: .formSheet,
            animated: true
        )
        waitForTitle(token: "vc2")
        waitForLabel(token: "vc2")

        let modalContext = modalToken?.context as? AnyForwardBackNavigationContext<String>
        XCTAssertNotNil(modalContext)

        modalContext?.navigateForward(token: "vc3", animated: true)
        waitForTitle(token: "vc3")
        waitForLabel(token: "vc3")
        waitForAbsenceOfLabel(token: "vc2")

        modalContext?.navigateForward(token: "vc4", animated: true)
        waitForTitle(token: "vc4")
        waitForLabel(token: "vc4")
        waitForAbsenceOfTitle(token: "vc2") // "Back" no longer shows "vc2"
    }

    private func renderUIAndAssert(token: String) -> AnyNavigationUIContext<String>? {
        let context = madog.renderUI(identifier: .navigation(), tokenData: .single(token), in: window)
        waitForTitle(token: token)
        waitForLabel(token: token)
        return context
    }

    private func navigateForwardAndAssert(token: String) {
        let modalContext = context as? AnyForwardBackNavigationContext<String>
        modalContext?.navigateForward(token: token, animated: true)
        waitForTitle(token: token)
        waitForLabel(token: token)
    }
}

#endif
