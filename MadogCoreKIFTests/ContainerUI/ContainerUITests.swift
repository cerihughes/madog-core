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
    func testCloseReleasesMainContainer() throws {
        let container = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)

        try closeContainerAndWait(container)
        XCTAssertNil(container.castValue)
    }

    func testCloseModalReleasesModalContainer() throws {
        let container = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)

        let modalContainer = try createModalContainer(container: container, token: "vc2")
        XCTAssertNotNil(modalContainer.castValue)

        try closeContainerAndWait(modalContainer)
        XCTAssertNotNil(container.castValue)
        XCTAssertNil(modalContainer.castValue)
    }

    func testCloseMainReleasesBothContainers() throws {
        let container = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)

        let modalContainer = try createModalContainer(container: container, token: "vc2")
        XCTAssertNotNil(modalContainer.castValue)

        try closeContainerAndWait(container)

        XCTAssertNil(container.castValue)
        XCTAssertNil(modalContainer.castValue)
        waitForLabel(token: "vc1") // Main UI should still be there
        waitForAbsenceOfLabel(token: "vc2")
    }

    func testCloseWithNestedContainers() throws {
        let container = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")

        let modalContainer1 = try createModalContainer(container: container, token: "vc2")
        XCTAssertNotNil(modalContainer1.castValue)

        let modalContainer2 = try createModalContainer(container: modalContainer1, token: "vc3")
        XCTAssertNotNil(modalContainer2.castValue)

        let modalContainer3 = try createModalContainer(container: modalContainer2, token: "vc4")
        XCTAssertNotNil(modalContainer3.castValue)

        XCTAssertNoThrow(try closeContainerAndWait(modalContainer2)) // Closes modals vc3 and vc4

        XCTAssertNotNil(container.castValue)
        XCTAssertNotNil(modalContainer1.castValue)
        XCTAssertNil(modalContainer2.castValue)
        XCTAssertNil(modalContainer3.castValue)
        waitForLabel(token: "vc2")
        waitForAbsenceOfLabel(token: "vc3")
        waitForAbsenceOfLabel(token: "vc4")

        try closeContainerAndWait(container) // Closes main and modal 1

        XCTAssertNil(container.castValue)
        XCTAssertNil(modalContainer1.castValue)
        waitForLabel(token: "vc1") // Main UI should still be there
        waitForAbsenceOfLabel(token: "vc2")
    }

    func testChangeReleasesOldModalContainers() throws {
        let container1 = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container1.castValue)

        let modalContainer1 = try createModalContainer(container: container1, token: "vc2")
        waitForLabel(token: "vc2")
        XCTAssertNotNil(modalContainer1.castValue)

        let modalContainer2 = try createModalContainer(container: modalContainer1, token: "vc3")
        waitForLabel(token: "vc3")
        XCTAssertNotNil(modalContainer2.castValue)

        let container2 = try container1.change(to: .test(), tokenData: .single("vc4"))
        waitForLabel(token: "vc4")

        XCTAssertNil(container1.castValue)
        XCTAssertNil(modalContainer1.castValue)
        XCTAssertNil(modalContainer2.castValue)
        XCTAssertNotNil(container2.castValue)
    }

    func testOpenSingleUIModal() throws {
        let container = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)

        let modalContainer = try createModalContainer(container: container, token: "vc2")
        waitForLabel(token: "vc2")
        XCTAssertNotNil(modalContainer.castValue)
    }

    func testCloseSingleUIModal() throws {
        let container = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)

        let modalToken = try createModal(container: container, token: "vc2")
        XCTAssertNotNil(modalToken)

        XCTAssertNoThrow(try closeModalAndWait(container.modal!, token: modalToken))
        waitForAbsenceOfTitle(token: "vc2")
    }

    func testOpenModalCompletionIsFired() throws {
        let container = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))

        let completionExpectation = expectation(description: "Modal opened")
        let modalToken = try openModalAndWait(container.modal!, identifier: .test(), tokenData: .single("vc2")) {
            completionExpectation.fulfill()
        }
        XCTAssertNotNil(modalToken.container.castValue)
        waitForExpectations(timeout: 10)
    }

    func testCloseModalCompletionIsFired() throws {
        let container = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))

        let modalToken = try openModalAndWait(container.modal!, identifier: .test(), tokenData: .single("vc2"))
        XCTAssertNotNil(modalToken)
        waitForLabel(token: "vc2")

        let completionExpectation = expectation(description: "Modal closed")
        try closeModalAndWait(container.modal!, token: modalToken) { completionExpectation.fulfill() }
        waitForExpectations(timeout: 10)
    }

    func testCloseCompletionIsFired() throws {
        let container = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))

        let openExpectation = expectation(description: "Modal opened")
        let modalToken = try openModalAndWait(container.modal!, identifier: .test(), tokenData: .single("vc2")) {
            openExpectation.fulfill()
        }
        wait(for: [openExpectation], timeout: 10)

        let modalContainer = modalToken.container
        let closeExpectation = expectation(description: "Container closed")

        try closeContainerAndWait(modalContainer) { closeExpectation.fulfill() }
        waitForExpectations(timeout: 10)
    }

    func testParentContainer() throws {
        let container = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))

        let openExpectation1 = expectation(description: "Modal 1 opened")
        var modalToken = try openModalAndWait(container.modal!, identifier: .test(), tokenData: .single("vc2")) {
            openExpectation1.fulfill()
        }
        wait(for: [openExpectation1], timeout: 10)
        let modalContainer1 = modalToken.container

        let openExpectation2 = expectation(description: "Modal 2 opened")
        modalToken = try openModalAndWait(modalContainer1.modal!, identifier: .test(), tokenData: .single("vc3")) {
            openExpectation2.fulfill()
        }
        wait(for: [openExpectation2], timeout: 10)

        let modalContainer2 = modalToken.container
        XCTAssertEqual(container.uuid, modalContainer1.parentContainer?.uuid)
        XCTAssertEqual(modalContainer1.uuid, modalContainer2.parentContainer?.uuid)
    }

    func testParentChildContainers() throws {
        let container = try renderUIAndWait(identifier: .test(), tokenData: .single("vc1"))

        let openExpectation1 = expectation(description: "Modal 1 opened")
        let modalToken = try openModalAndWait(container.modal!, identifier: .test(), tokenData: .single("vc2")) {
            openExpectation1.fulfill()
        }
        wait(for: [openExpectation1], timeout: 10)

        let modalContainer1 = modalToken.container
        let childContainer = try XCTUnwrap(container.childContainers.first)
        let parentContainer = try XCTUnwrap(modalContainer1.parentContainer)

        XCTAssertEqual(childContainer.uuid, modalContainer1.uuid)
        XCTAssertEqual(parentContainer.uuid, container.uuid)

        typealias ContainerProxyType = ContainerProxy<String, SingleUITokenData<String>, ViewController>
        // Returned relationships should be proxies, not containers
        XCTAssertTrue(childContainer is ContainerProxyType)
        XCTAssertTrue(parentContainer is ContainerProxyType)
    }

    private func createModal(
        container: AnyContainer<String>,
        token: String
    ) throws -> ModalToken<String> {
        let openExpectation = expectation(description: "Modal \(token) opened")
        let modalToken = try openModalAndWait(container.modal!, identifier: .test(), tokenData: .single(token)) {
            openExpectation.fulfill()
        }
        wait(for: [openExpectation], timeout: 10)
        waitForLabel(token: token)
        return modalToken
    }

    private func createModalContainer(container: AnyContainer<String>, token: String) throws -> AnyContainer<String> {
        try createModal(container: container, token: token).container
    }
}

#endif
