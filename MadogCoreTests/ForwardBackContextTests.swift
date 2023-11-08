//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import XCTest

@testable import MadogCore

class ForwardBackContextTests: XCTestCase {
    private var madog: Madog<Int>!

    override func setUp() {
        super.setUp()

        madog = Madog()
        madog.resolve(resolver: TestResolver())
        madog.addContainerFactory(identifier: .test(), factory: TestContainerFactory())
        madog.addContainerFactory(identifier: .testNavigation(), factory: TestNavigatingContainerFactory())
    }

    override func tearDown() {
        madog = nil

        super.tearDown()
    }

    func testContextIsForwardBack() throws {
        let window = Window()

        let context1 = try XCTUnwrap(madog.renderUI(identifier: .test(), tokenData: .single(0), in: window))
        XCTAssertNil(context1.forwardBack)

        let context2 = try XCTUnwrap(madog.renderUI(identifier: .testNavigation(), tokenData: .single(0), in: window))
        XCTAssertNotNil(context2.forwardBack)
    }
}

#endif
