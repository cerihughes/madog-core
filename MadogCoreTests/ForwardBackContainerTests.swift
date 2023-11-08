//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import XCTest

@testable import MadogCore

class ForwardBackContainerTests: XCTestCase {
    private var madog: Madog<Int>!

    override func setUp() {
        super.setUp()

        madog = Madog()
        madog.resolve(resolver: TestResolver())
        madog.addContainerUIFactory(identifier: .test(), factory: TestContainerUIFactory())
        madog.addContainerUIFactory(identifier: .testNavigation(), factory: TestNavigatingContainerUIFactory())
    }

    override func tearDown() {
        madog = nil

        super.tearDown()
    }

    func testContainerIsForwardBack() throws {
        let window = Window()

        let container1 = try XCTUnwrap(madog.renderUI(identifier: .test(), tokenData: .single(0), in: window))
        XCTAssertNil(container1.forwardBack)

        let container2 = try XCTUnwrap(madog.renderUI(identifier: .testNavigation(), tokenData: .single(0), in: window))
        XCTAssertNotNil(container2.forwardBack)
    }
}

#endif
