//
//  Created by Ceri Hughes on 06/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(KIF) && canImport(UIKit)

import KIF
import MadogCoreTestUtilities
import XCTest

@testable import MadogCore

class ContainerUITests: MadogKIFTestCase {
    func testCloseReleasesMainContainer() {
        let container = renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)

        closeContainerAndWait(container)
        XCTAssertNil(container.castValue)
    }

    func testCloseModalReleasesModalContainer() {
        let container = renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)

        let modalContainer = createModalContainer(container: container, token: "vc2")
        XCTAssertNotNil(modalContainer.castValue)

        closeContainerAndWait(modalContainer)
        XCTAssertNotNil(container.castValue)
        XCTAssertNil(modalContainer.castValue)
    }

    func testCloseMainReleasesBothContainers() {
        let container = renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)

        let modalContainer = createModalContainer(container: container, token: "vc2")
        XCTAssertNotNil(modalContainer.castValue)

        closeContainerAndWait(container)

        XCTAssertNil(container.castValue)
        XCTAssertNil(modalContainer.castValue)
        waitForLabel(token: "vc1") // Main UI should still be there
        waitForAbsenceOfLabel(token: "vc2")
    }

    func testCloseWithNestedContainers() {
        let container = renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")

        let modalContainer1 = createModalContainer(container: container, token: "vc2")
        XCTAssertNotNil(modalContainer1.castValue)

        let modalContainer2 = createModalContainer(container: modalContainer1, token: "vc3")
        XCTAssertNotNil(modalContainer2.castValue)

        let modalContainer3 = createModalContainer(container: modalContainer2, token: "vc4")
        XCTAssertNotNil(modalContainer3.castValue)

        XCTAssertTrue(closeContainerAndWait(modalContainer2)) // Closes modals vc3 and vc4

        XCTAssertNotNil(container.castValue)
        XCTAssertNotNil(modalContainer1.castValue)
        XCTAssertNil(modalContainer2.castValue)
        XCTAssertNil(modalContainer3.castValue)
        waitForLabel(token: "vc2")
        waitForAbsenceOfLabel(token: "vc3")
        waitForAbsenceOfLabel(token: "vc4")

        closeContainerAndWait(container) // Closes main and modal 1

        XCTAssertNil(container.castValue)
        XCTAssertNil(modalContainer1.castValue)
        waitForLabel(token: "vc1") // Main UI should still be there
        waitForAbsenceOfLabel(token: "vc2")
    }

    func testChangeReleasesOldModalContainers() {
        let container1 = renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container1.castValue)

        let modalContainer1 = createModalContainer(container: container1, token: "vc2")
        waitForLabel(token: "vc2")
        XCTAssertNotNil(modalContainer1.castValue)

        let modalContainer2 = createModalContainer(container: modalContainer1, token: "vc3")
        waitForLabel(token: "vc3")
        XCTAssertNotNil(modalContainer2.castValue)

        let container2 = container1.change(to: .test(), tokenData: .single("vc4"))!
        waitForLabel(token: "vc4")

        XCTAssertNil(container1.castValue)
        XCTAssertNil(modalContainer1.castValue)
        XCTAssertNil(modalContainer2.castValue)
        XCTAssertNotNil(container2.castValue)
    }

    func testOpenSingleUIModal() {
        let container = renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)

        let modalContainer = createModalContainer(container: container, token: "vc2")
        waitForLabel(token: "vc2")
        XCTAssertNotNil(modalContainer.castValue)
    }

    func testCloseSingleUIModal() {
        let container = renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)

        let modalToken = createModal(container: container, token: "vc2")
        XCTAssertNotNil(modalToken)

        XCTAssertTrue(closeModalAndWait(container.modal!, token: modalToken))
        waitForAbsenceOfTitle(token: "vc2")
    }

    func testOpenModalCompletionIsFired() {
        let container = renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))

        let completionExpectation = expectation(description: "Modal opened")
        let modalToken = openModalAndWait(container.modal!, identifier: .test(), tokenData: .single("vc2")) {
            completionExpectation.fulfill()
        }
        XCTAssertNotNil(modalToken.container.castValue)
        waitForExpectations(timeout: 10)
    }

    func testCloseModalCompletionIsFired() {
        let container = renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))

        let modalToken = openModalAndWait(container.modal!, identifier: .test(), tokenData: .single("vc2"))
        XCTAssertNotNil(modalToken)
        waitForLabel(token: "vc2")

        let completionExpectation = expectation(description: "Modal closed")
        closeModalAndWait(container.modal!, token: modalToken) { completionExpectation.fulfill() }
        waitForExpectations(timeout: 10)
    }

    func testCloseCompletionIsFired() {
        let container = renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))

        let openExpectation = expectation(description: "Modal opened")
        let modalToken = openModalAndWait(container.modal!, identifier: .test(), tokenData: .single("vc2")) {
            openExpectation.fulfill()
        }
        wait(for: [openExpectation], timeout: 10)

        let modalContainer = modalToken.container
        let closeExpectation = expectation(description: "Container closed")

        closeContainerAndWait(modalContainer) { closeExpectation.fulfill() }
        waitForExpectations(timeout: 10)
    }

    func testParentContainer() {
        let container = renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        XCTAssertNil(container.parentContainer)

        let openExpectation1 = expectation(description: "Modal 1 opened")
        var modalToken = openModalAndWait(container.modal!, identifier: .test(), tokenData: .single("vc2")) {
            openExpectation1.fulfill()
        }
        wait(for: [openExpectation1], timeout: 10)
        let modalContainer1 = modalToken.container

        let openExpectation2 = expectation(description: "Modal 2 opened")
        modalToken = openModalAndWait(modalContainer1.modal!, identifier: .test(), tokenData: .single("vc3")) {
            openExpectation2.fulfill()
        }
        wait(for: [openExpectation2], timeout: 10)

        let modalContainer2 = modalToken.container
        XCTAssertTrue(container.uuid == modalContainer1.parentContainer?.uuid)
        XCTAssertTrue(modalContainer1.uuid == modalContainer2.parentContainer?.uuid)
    }

    private func createModal(
        container: AnyContainer<String>,
        token: String
    ) -> ModalToken<String> {
        let openExpectation = expectation(description: "Modal \(token) opened")
        let modalToken = openModalAndWait(container.modal!, identifier: .test(), tokenData: .single(token)) {
            openExpectation.fulfill()
        }
        wait(for: [openExpectation], timeout: 10)
        waitForLabel(token: token)
        return modalToken
    }

    private func createModalContainer(container: AnyContainer<String>, token: String) -> AnyContainer<String> {
        createModal(container: container, token: token).container
    }
}

#endif
