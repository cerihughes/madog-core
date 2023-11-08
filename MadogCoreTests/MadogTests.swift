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
        madog.addContainerFactory(identifier: .test(), factory: TestContainerFactory())
    }

    override func tearDown() {
        madog = nil

        super.tearDown()
    }

    func testMadogKeepsStrongReferenceToCurrentContext() throws {
        let window = Window()

        weak var context1: TestContainer<Int>?
        try autoreleasepool {
            context1 = try madog.renderUI(identifier: .test(), tokenData: .single(0), in: window)?.asContainer()
            XCTAssertNotNil(context1)
        }

        weak var context2 = try madog.renderUI(identifier: .test(), tokenData: .single(1), in: window)?.asContainer()
        XCTAssertNil(context1)
        XCTAssertNotNil(context2)
    }

    func testMadogReleasesContext() throws {
        let window = Window()
        let tracker = DeallocationTracker()

        try autoreleasepool {
            weak var context = try madog.renderUI(identifier: .test(), tokenData: .single(0), in: window)?.asContainer()
            XCTAssertNotNil(context)
            try context?.assignDelegate(tracker)
        }

        XCTAssertEqual(tracker.deallocations, 0)

        try autoreleasepool {
            weak var context = try madog.renderUI(identifier: .test(), tokenData: .single(0), in: window)?.asContainer()
            XCTAssertNotNil(context)
            try context?.assignDelegate(tracker)
        }

        XCTAssertEqual(tracker.deallocations, 1)

        try autoreleasepool {
            weak var context = try madog.renderUI(identifier: .test(), tokenData: .single(0), in: window)?.asContainer()
            XCTAssertNotNil(context)
            try context?.assignDelegate(tracker)
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

private extension AnyContext where T == Int {
    func asContainer() throws -> TestContainer<Int> {
        let wrapped = try XCTUnwrap(self as? WeakContextHolder<Int>)
        return try XCTUnwrap(wrapped.wrapped as? TestContainer<Int>)
    }
}

private extension TestContainer {
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
