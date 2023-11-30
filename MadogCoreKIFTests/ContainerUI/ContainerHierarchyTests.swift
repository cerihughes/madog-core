//
//  Created by Ceri Hughes on 20/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(KIF) && canImport(UIKit)

import KIF
import MadogCoreTestUtilities
import XCTest

@testable import MadogCore
@testable import MadogCoreTests

class ContainerHierarchyTests: MadogKIFTestCase {
    func testNestedContainers() throws {
        let container = try renderUIAndWait(identifier: .testTabBar(), tokenData: .multi(
            .create(identifier: .testNavigation(), tokenData: .single("vc1")) {
                $0.tabBarItem.title = "vc1"
            },
            .create(identifier: .testNavigation(), tokenData: .single("vc2")) {
                $0.tabBarItem.title = "vc2"
            }
        ))
        waitForTitle(token: "vc1")
        waitForTitle(token: "vc2")
        waitForLabel(token: "vc1")
        XCTAssertNotNil(container.castValue)
        XCTAssertEqual(container.childContainers.count, 2)

        try closeContainerAndWait(container)
        XCTAssertNil(container.castValue)
    }

    func testNestedContainersWithNavigation() throws {
        let container = try renderUIAndWait(identifier: .testTabBar(), tokenData: .multi(
            .create(identifier: .testNavigation(), tokenData: .single("vc1")),
            .create(identifier: .testNavigation(), tokenData: .single("vc2"))
        ))
        waitForLabel(token: "vc1")

        let nav1 = container.childContainers[0]
        let nav2 = container.childContainers[1]

        try nav1.forwardBack?.navigateForward(token: "vc3", animated: true)
        waitForLabel(token: "vc3")

        container.multi?.selectedIndex = 1
        waitForLabel(token: "vc2")

        try nav2.forwardBack?.navigateForward(token: "vc4", animated: true)
        waitForLabel(token: "vc4")
        try nav2.forwardBack?.navigateForward(token: "vc5", animated: true)
        waitForLabel(token: "vc5")

        container.multi?.selectedIndex = 0
        waitForLabel(token: "vc3")
        try nav1.forwardBack?.navigateBack(animated: true)
        waitForLabel(token: "vc1")

        container.multi?.selectedIndex = 1
        try nav2.forwardBack?.navigateBack(animated: true)
        waitForLabel(token: "vc4")

        try nav2.forwardBack?.navigateBack(animated: true)
        waitForLabel(token: "vc2")
    }

    func testNestedContainersAreAllReleasedOnChange() throws {
        let container1 = try renderUIAndWait(identifier: .testTabBar(), tokenData: .multi(
            .create(identifier: .testNavigation(), tokenData: .single("vc1")),
            .create(identifier: .testNavigation(), tokenData: .single("vc2"))
        ))
        waitForLabel(token: "vc1")

        let nav1 = container1.childContainers[0]
        let nav2 = container1.childContainers[1]

        try nav1.forwardBack?.navigateForward(token: "vc3", animated: true)
        waitForLabel(token: "vc3")

        container1.multi?.selectedIndex = 1
        waitForLabel(token: "vc2")

        try nav2.forwardBack?.navigateForward(token: "vc4", animated: true)
        waitForLabel(token: "vc4")

        let container2 = try container1.change(to: .test(), tokenData: .single("vc5"))
        waitForLabel(token: "vc5")

        XCTAssertNil(container1.castValue)
        XCTAssertNil(nav1.castValue)
        XCTAssertNil(nav2.castValue)
        XCTAssertNotNil(container2.castValue)
    }
}

#endif
