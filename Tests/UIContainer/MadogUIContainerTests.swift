//
//  MadogUIContainerTests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class MadogUIContainerTests: MadogKIFTestCase {
    func testCloseReleasesMainContext() {
        weak var context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window)
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        context?.close(animated: true)
        XCTAssertNil(context)
    }

    func testCloseModalReleasesModalContext() {
        weak var context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? ModalContext
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        weak var modalContext = createModalContext(context: context!, token: "vc2")
        XCTAssertNotNil(modalContext)

        modalContext?.close(animated: true)
        XCTAssertNotNil(context)
        XCTAssertNil(modalContext)
    }

    func testCloseMainReleasesBothContexts() {
        weak var context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? BasicUIContext
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        weak var modalContext = createModalContext(context: context!, token: "vc2")
        XCTAssertNotNil(modalContext)

        context?.close(animated: true)
        XCTAssertNil(context)
        XCTAssertNil(modalContext)
        waitForLabel(token: "vc1") // Main UI should still be there
        waitForAbsenceOfLabel(token: "vc2")
    }

    func testCloseWithNestedContexts() {
        weak var context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? BasicUIContext
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        weak var modal1Context = createModalContext(context: context!, token: "vc2") as? ModalContext
        XCTAssertNotNil(modal1Context)

        weak var modal2Context = createModalContext(context: modal1Context!, token: "vc3") as? BasicUIContext
        XCTAssertNotNil(modal2Context)

        weak var modal3Context = createModalContext(context: modal2Context!, token: "vc4") as? ModalContext
        XCTAssertNotNil(modal3Context)

        XCTAssertTrue(modal2Context!.close(animated: true)) // Closes modals vc3 and vc4
        XCTAssertNotNil(context)
        XCTAssertNotNil(modal1Context)
        XCTAssertNil(modal2Context)
        XCTAssertNil(modal3Context)
        waitForLabel(token: "vc2")
        waitForAbsenceOfLabel(token: "vc3")
        waitForAbsenceOfLabel(token: "vc4")

        context?.close(animated: true) // Closes main and modal 1
        XCTAssertNil(context)
        XCTAssertNil(modal1Context)
        waitForLabel(token: "vc1") // Main UI should still be there
        waitForAbsenceOfLabel(token: "vc2")
    }

    func testChangeSingleToMulti() {
        var context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window)
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        context = context?.change(to: .tabBar, tokenData: .multi(["vc2", "vc3"]))
        waitForAbsenceOfLabel(token: "vc1")
        waitForTitle(token: "vc2") // Titles should appear in the tab bar
        waitForTitle(token: "vc3")
        XCTAssertNotNil(context)
    }

    func testChangeMultiToSingle() {
        var context = madog.renderUI(identifier: .tabBar, tokenData: .multi(["vc1", "vc2"]), in: window)
        waitForTitle(token: "vc1") // Titles should appear in the tab bar
        waitForTitle(token: "vc2")
        XCTAssertNotNil(context)

        context = context?.change(to: .basic, tokenData: .single("vc3"))
        waitForAbsenceOfTitle(token: "vc1")
        waitForAbsenceOfTitle(token: "vc2")
        waitForLabel(token: "vc3")
        XCTAssertNotNil(context)
    }

    func testChangeReleasesOldModalContexts() {
        weak var context1 = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? BasicUIContext
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context1)

        weak var modal1Context = createModalContext(context: context1!, token: "vc2") as? ModalContext
        waitForLabel(token: "vc2")
        XCTAssertNotNil(modal1Context)

        weak var modal2Context = createModalContext(context: modal1Context!, token: "vc3") as? BasicUIContext
        waitForLabel(token: "vc3")
        XCTAssertNotNil(modal2Context)

        weak var context2 = context1?.change(to: .basic, tokenData: .single("vc4"))
        waitForLabel(token: "vc4")

        XCTAssertNil(context1)
        XCTAssertNil(modal1Context)
        XCTAssertNil(modal2Context)
        XCTAssertNotNil(context2)
    }

    func testOpenSingleUIModal() {
        let context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? ModalContext
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        let modalContext = createModalContext(context: context!, token: "vc2")
        waitForLabel(token: "vc2")
        XCTAssertNotNil(modalContext)
    }

    func testCloseSingleUIModal() {
        let context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? ModalContext
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        let modalToken = createModal(context: context!, token: "vc2")
        XCTAssertNotNil(modalToken)

        XCTAssertTrue(context!.closeModal(token: modalToken!, animated: true))
        waitForAbsenceOfTitle(token: "vc2")
    }

    func testOpenMultiUIModal() {
        let context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? ModalContext
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        let modalContext = createModalContext(context: context!, tokens: ["vc2", "vc3"]) as? TabBarUIContext
        waitForTitle(token: "vc2") // Titles should appear in the tab bar
        waitForTitle(token: "vc3")
        XCTAssertNotNil(modalContext)
    }

    func testCloseMultiUIModal() {
        let context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? ModalContext
        waitForLabel(token: "vc1")
        XCTAssertNotNil(context)

        let modalToken = createModal(context: context!, tokens: ["vc2", "vc3"])
        waitForTitle(token: "vc2") // Titles should appear in the tab bar
        waitForTitle(token: "vc3")
        XCTAssertNotNil(modalToken)

        XCTAssertTrue(context!.closeModal(token: modalToken!, animated: true))
        waitForAbsenceOfTitle(token: "vc2")
        waitForAbsenceOfTitle(token: "vc3")
    }

    func testOpenModalCompletionIsFired() {
        let context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? ModalContext

        let completionExpectation = expectation(description: "Completion fired")
        let modalToken = context!.openModal(identifier: .basic,
                                            tokenData: .single("vc2"),
                                            presentationStyle: .formSheet,
                                            animated: true,
                                            completion: { completionExpectation.fulfill() })
        XCTAssertNotNil(modalToken)
        waitForExpectations(timeout: 10)
    }

    func testCloseModalCompletionIsFired() {
        let context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? ModalContext

        let modalToken = context!.openModal(identifier: .basic,
                                            tokenData: .single("vc2"),
                                            presentationStyle: .formSheet,
                                            animated: true)
        XCTAssertNotNil(modalToken)
        waitForLabel(token: "vc2")

        let completionExpectation = expectation(description: "Completion fired")
        context!.closeModal(token: modalToken!, animated: true, completion: { completionExpectation.fulfill() })
        waitForExpectations(timeout: 10)
    }

    func testCloseCompletionIsFired() {
        let context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? ModalContext

        let modalToken = context!.openModal(identifier: .basic,
                                            tokenData: .single("vc2"),
                                            presentationStyle: .formSheet,
                                            animated: true)

        let modalContext = modalToken!.context
        let completionExpectation = expectation(description: "Completion fired")
        modalContext.close(animated: true, completion: { completionExpectation.fulfill() })
        waitForExpectations(timeout: 10)
    }

    func testPresentingContext() {
        let context = madog.renderUI(identifier: .basic, tokenData: .single("vc1"), in: window) as? BasicUIContext
        XCTAssertNil(context?.presentingContext)

        let completionExpectation1 = expectation(description: "Completion fired")
        var modalToken = context!.openModal(identifier: .basic,
                                            tokenData: .single("vc2"),
                                            presentationStyle: .formSheet,
                                            animated: true,
                                            completion: { completionExpectation1.fulfill() })
        wait(for: [completionExpectation1], timeout: 10)
        let modalContext1 = modalToken?.context as? BasicUIContext

        let completionExpectation2 = expectation(description: "Completion fired")
        modalToken = modalContext1!.openModal(identifier: .basic,
                                              tokenData: .single("vc3"),
                                              presentationStyle: .formSheet,
                                              animated: true,
                                              completion: { completionExpectation2.fulfill() })
        wait(for: [completionExpectation2], timeout: 10)
        let modalContext2 = modalToken?.context as? BasicUIContext

        XCTAssertTrue(context === modalContext1?.presentingContext)
        XCTAssertTrue(modalContext1 === modalContext2?.presentingContext)
    }

    private func createModal(context: ModalContext, token: String) -> ModalToken? {
        let modalToken = context.openModal(identifier: .basic,
                                           tokenData: .single(token),
                                           presentationStyle: .formSheet,
                                           animated: true)
        waitForLabel(token: token)
        return modalToken
    }

    private func createModalContext(context: ModalContext, token: String) -> Context? {
        let modalToken = createModal(context: context, token: token)
        return modalToken?.context
    }

    private func createModal(context: ModalContext, tokens: [String]) -> ModalToken? {
        let modalToken = context.openModal(identifier: .tabBar,
                                           tokenData: .multi(tokens),
                                           presentationStyle: .formSheet,
                                           animated: true)
        tokens.forEach { waitForTitle(token: $0) }

        return modalToken
    }

    private func createModalContext(context: ModalContext, tokens: [String]) -> Context? {
        let modalToken = createModal(context: context, tokens: tokens)
        return modalToken?.context
    }
}

#endif
