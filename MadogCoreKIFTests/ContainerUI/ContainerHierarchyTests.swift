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
    func testCloseReleasesMainContainer() {
        let container = renderUIAndWait(identifier: .testTabBar(), tokenData: .multi(
            .create(identifier: .testNavigation(), tokenData: .single("vc1")),
            .create(identifier: .testNavigation(), tokenData: .single("vc2"))
        ))
        container.multi?.selectedIndex = 0
        waitForLabel(token: "vc1")
        container.multi?.selectedIndex = 1
        waitForLabel(token: "vc2")
        XCTAssertNotNil(container.castValue)

        closeContainerAndWait(container)
        XCTAssertNil(container.castValue)
    }
}

#endif
