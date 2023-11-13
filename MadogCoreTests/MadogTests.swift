//
//  Created by Ceri Hughes on 23/08/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import MadogCore

class MadogTests: XCTestCase {
    private var madog: Madog<Int>!

    override func setUp() {
        super.setUp()

        madog = Madog()
        madog.resolve(resolver: TestResolver())
        madog.addContainerUIFactory(identifier: .test(), factory: TestContainerUI.Factory())
    }

    override func tearDown() {
        madog = nil

        super.tearDown()
    }

    func testMadogKeepsStrongReferenceToCurrentContainer() throws {
        let window = Window()

        weak var impl1: TestContainerUI<Int>?
        try autoreleasepool {
            impl1 = try madog.renderUI(identifier: .test(), tokenData: .single(0), in: window)?.asImpl()
            XCTAssertNotNil(impl1)
        }

        weak var impl2 = try madog.renderUI(identifier: .test(), tokenData: .single(1), in: window)?.asImpl()
        XCTAssertNil(impl1)
        XCTAssertNotNil(impl2)
    }

    func testMadogReleasesContainer() throws {
        let window = Window()
        let tracker = DeallocationTracker()

        try autoreleasepool {
            weak var impl = try madog.renderUI(identifier: .test(), tokenData: .single(0), in: window)?.asImpl()
            XCTAssertNotNil(impl)
            try impl?.assignDelegate(tracker)
        }

        XCTAssertEqual(tracker.deallocations, 0)

        try autoreleasepool {
            weak var impl = try madog.renderUI(identifier: .test(), tokenData: .single(0), in: window)?.asImpl()
            XCTAssertNotNil(impl)
            try impl?.assignDelegate(tracker)
        }

        XCTAssertEqual(tracker.deallocations, 1)

        try autoreleasepool {
            weak var impl = try madog.renderUI(identifier: .test(), tokenData: .single(0), in: window)?.asImpl()
            XCTAssertNotNil(impl)
            try impl?.assignDelegate(tracker)
        }

        XCTAssertEqual(tracker.deallocations, 2)
    }

    func testServiceProviderAccess() {
        madog = Madog()
        XCTAssertEqual(madog.serviceProviders.count, 0)

        madog.resolve(resolver: TestResolver())
        XCTAssertEqual(madog.serviceProviders.count, 1)
    }
}

private extension AnyContainer where T == Int {
    func asImpl() throws -> TestContainerUI<Int> {
        let wrapped = try XCTUnwrap(self as? ContainerProxy<Int, ViewController>)
        return try XCTUnwrap(wrapped.wrapped as? TestContainerUI<Int>)
    }
}

private extension TestContainerUI {
    func assignDelegate(_ delegate: TestViewControllerDelegate) throws {
        let vc = try XCTUnwrap(viewController.children[0] as? TestViewController<Int>)
        vc.delegate = delegate
    }
}

private class DeallocationTracker: TestViewControllerDelegate {
    var deallocations = 0
    func testViewControllerDidDeallocate() {
        deallocations += 1
    }
}
