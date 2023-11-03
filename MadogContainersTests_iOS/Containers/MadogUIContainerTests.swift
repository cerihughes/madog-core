//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import KIF
import MadogCore
import XCTest

@testable import MadogContainers_iOS

class MadogUIContainerTests: MadogKIFTestCase {
    func testCloseReleasesMainContext() {
        weak var context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        closeContextAndWait(context!)
        XCTAssertNil(context)
    }

    func testCloseModalReleasesModalContext() {
        weak var context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        weak var modalContext = createModalContext(context: context!, token: "vc2")
        XCTAssertNotNil(modalContext)

        closeContextAndWait(modalContext!)
        XCTAssertNotNil(context)
        XCTAssertNil(modalContext)
    }

    func testCloseMainReleasesBothContexts() {
        weak var context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        weak var modalContext = createModalContext(context: context!, token: "vc2")
        XCTAssertNotNil(modalContext)

        closeContextAndWait(context!)

        XCTAssertNil(context)
        XCTAssertNil(modalContext)
        waitForLabel(token: "vc1") // Main UI should still be there
        waitForAbsenceOfLabel(token: "vc2")
    }

    func testCloseWithNestedContexts() {
        weak var context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        weak var modal1Context = createModalContext(context: context!, token: "vc2")
        XCTAssertNotNil(modal1Context)

        weak var modal2Context = createModalContext(context: modal1Context!, token: "vc3")
        XCTAssertNotNil(modal2Context)

        weak var modal3Context = createModalContext(context: modal2Context!, token: "vc4")
        XCTAssertNotNil(modal3Context)

        XCTAssertTrue(closeContextAndWait(modal2Context!)) // Closes modals vc3 and vc4

        XCTAssertNotNil(context)
        XCTAssertNotNil(modal1Context)
        XCTAssertNil(modal2Context)
        XCTAssertNil(modal3Context)
        waitForLabel(token: "vc2")
        waitForAbsenceOfLabel(token: "vc3")
        waitForAbsenceOfLabel(token: "vc4")

        closeContextAndWait(context!) // Closes main and modal 1

        XCTAssertNil(context)
        XCTAssertNil(modal1Context)
        waitForLabel(token: "vc1") // Main UI should still be there
        waitForAbsenceOfLabel(token: "vc2")
    }

    func testChangeSingleToMulti() {
        let context1 = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context1)

        let context2 = context1?.change(to: .tabBar(), tokenData: .multi("vc2", "vc3"))
        waitForAbsenceOfLabel(token: "vc1")
        waitForTitle(token: "vc2") // Titles should appear in the tab bar
        waitForTitle(token: "vc3")
        XCTAssertNotNil(context2)
    }

    func testChangeMultiToSingle() {
        let context1 = renderUIAndWait(identifier: .tabBar(), tokenData: .multi("vc1", "vc2"))
        waitForTitle(token: "vc1") // Titles should appear in the tab bar
        waitForTitle(token: "vc2")
        XCTAssertNotNil(context1)

        let context2 = context1?.change(to: .basic(), tokenData: .single("vc3"))
        waitForAbsenceOfTitle(token: "vc1")
        waitForAbsenceOfTitle(token: "vc2")
        waitForLabel(token: "vc3")
        XCTAssertNotNil(context2)
    }

    func testChangeReleasesOldModalContexts() {
        weak var context1 = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context1)

        weak var modal1Context = createModalContext(context: context1!, token: "vc2")
        waitForLabel(token: "vc2")
        XCTAssertNotNil(modal1Context)

        weak var modal2Context = createModalContext(context: modal1Context!, token: "vc3")
        waitForLabel(token: "vc3")
        XCTAssertNotNil(modal2Context)

        weak var context2 = context1?.change(to: .basic(), tokenData: .single("vc4"))
        waitForLabel(token: "vc4")

        XCTAssertNil(context1)
        XCTAssertNil(modal1Context)
        XCTAssertNil(modal2Context)
        XCTAssertNotNil(context2)
    }

    func testOpenSingleUIModal() {
        let context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        let modalContext = createModalContext(context: context!, token: "vc2")
        waitForLabel(token: "vc2")
        XCTAssertNotNil(modalContext)
    }

    func testCloseSingleUIModal() {
        let context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        let modalToken = createModal(context: context!, token: "vc2")
        XCTAssertNotNil(modalToken)

        XCTAssertTrue(closeModalAndWait(context!, token: modalToken!))
        waitForAbsenceOfTitle(token: "vc2")
    }

    func testOpenMultiUIModal() {
        let context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        let modalContext = createModalContext(context: context!, tokens: ["vc2", "vc3"])
        waitForTitle(token: "vc2") // Titles should appear in the tab bar
        waitForTitle(token: "vc3")
        XCTAssertNotNil(modalContext)
    }

    func testCloseMultiUIModal() {
        let context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        let modalToken = createModal(context: context!, tokens: ["vc2", "vc3"])
        waitForTitle(token: "vc2") // Titles should appear in the tab bar
        waitForTitle(token: "vc3")
        XCTAssertNotNil(modalToken)

        XCTAssertTrue(closeModalAndWait(context!, token: modalToken!))
        waitForAbsenceOfTitle(token: "vc2")
        waitForAbsenceOfTitle(token: "vc3")
    }

    func testOpenModalCompletionIsFired() {
        let context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))

        let completionExpectation = expectation(description: "Modal opened")
        let modalToken = openModalAndWait(context!, identifier: .basic(), tokenData: .single("vc2")) {
            completionExpectation.fulfill()
        }
        XCTAssertNotNil(modalToken)
        waitForExpectations(timeout: 10)
    }

    func testCloseModalCompletionIsFired() {
        let context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))

        let modalToken = openModalAndWait(context!, identifier: .basic(), tokenData: .single("vc2"))
        XCTAssertNotNil(modalToken)
        waitForLabel(token: "vc2")

        let completionExpectation = expectation(description: "Modal closed")
        closeModalAndWait(context!, token: modalToken!) { completionExpectation.fulfill() }
        waitForExpectations(timeout: 10)
    }

    func testCloseCompletionIsFired() {
        let context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))

        let openExpectation = expectation(description: "Modal opened")
        let modalToken = openModalAndWait(context!, identifier: .basic(), tokenData: .single("vc2")) {
            openExpectation.fulfill()
        }
        wait(for: [openExpectation], timeout: 10)

        let modalContext = modalToken!.context
        let closeExpectation = expectation(description: "Context closed")

        closeContextAndWait(modalContext) { closeExpectation.fulfill() }
        waitForExpectations(timeout: 10)
    }

    func testPresentingContext() {
        let context = renderUIAndWait(identifier: .basic(), tokenData: .single("vc1"))
        XCTAssertNil(context?.presentingContext)

        let openExpectation1 = expectation(description: "Modal 1 opened")
        var modalToken = openModalAndWait(context!, identifier: .basic(), tokenData: .single("vc2")) {
            openExpectation1.fulfill()
        }
        wait(for: [openExpectation1], timeout: 10)
        let modalContext1 = modalToken?.context

        let openExpectation2 = expectation(description: "Modal 2 opened")
        modalToken = openModalAndWait(modalContext1!, identifier: .basic(), tokenData: .single("vc3")) {
            openExpectation2.fulfill()
        }
        wait(for: [openExpectation2], timeout: 10)
        let modalContext2 = modalToken?.context as? AnyContext<String>

        XCTAssertTrue(context === modalContext1?.presentingContext)
        XCTAssertTrue(modalContext1 === modalContext2?.presentingContext)
    }

    private func createModal(
        context: AnyContext<String>,
        token: String
    ) -> AnyModalToken<AnyContext<String>>? {
        let openExpectation = expectation(description: "Modal \(token) opened")
        let modalToken = openModalAndWait(context, identifier: .basic(), tokenData: .single(token)) {
            openExpectation.fulfill()
        }
        wait(for: [openExpectation], timeout: 10)
        waitForLabel(token: token)
        return modalToken
    }

    private func createModalContext(context: AnyContext<String>, token: String) -> AnyContext<String>? {
        let modalToken = createModal(context: context, token: token)
        return modalToken?.context as? AnyContext<String>
    }

    private func createModal(
        context: AnyContext<String>,
        tokens: [String]
    ) -> AnyModalToken<AnyMultiContext<String>>? {
        let openExpectation = expectation(description: "Modal \(tokens) opened")
        let modalToken = openModalAndWait(context, identifier: .tabBar(), tokenData: .multi(tokens)) {
            openExpectation.fulfill()
        }
        wait(for: [openExpectation], timeout: 10)
        tokens.forEach { waitForTitle(token: $0) }
        return modalToken
    }

    private func createModalContext(context: AnyContext<String>, tokens: [String]) -> AnyContext<String>? {
        let modalToken = createModal(context: context, tokens: tokens)
        return modalToken?.context as? AnyContext<String>
    }
}
