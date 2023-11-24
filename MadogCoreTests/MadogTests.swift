//
//  Created by Ceri Hughes on 23/08/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCoreTestContainers
import XCTest

#if canImport(UIKit)

typealias SingleTokenVC = UINavigationController
typealias MultiTokenVC = UITabBarController
typealias SplitTokenVC = UISplitViewController

#elseif canImport(AppKit)

typealias SingleTokenVC = NSPageController
typealias MultiTokenVC = NSTabViewController
typealias SplitTokenVC = NSSplitViewController

#endif

@testable import MadogCore

class MadogTests: XCTestCase {
    private var madog: Madog<Int>!

    override func setUp() {
        super.setUp()

        madog = Madog()
        madog.resolve(resolver: TestResolver())
        madog.registerTestContainers()
    }

    override func tearDown() {
        madog = nil

        super.tearDown()
    }

    func testMadogKeepsStrongReferenceToCurrentContainer() throws {
        let window = Window()

        weak var impl1: AnyObject?
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

    func testSingleTokenFactory() {
        typealias TD = SingleUITokenData<Int>
        typealias VC = SingleTokenVC
        class TestContainer: ContainerUI<Int, TD, VC> {}
        class TestFactory: ContainerUIFactory {
            func createContainer() -> ContainerUI<Int, TD, VC> {
                TestContainer(containerViewController: .init())
            }
        }

        let identifier = ContainerUI<Int, TD, VC>.Identifier("testSingleTokenFactory")
        XCTAssertTrue(madog.addContainerUIFactory(identifier: identifier, factory: TestFactory()))
        XCTAssertNotNil(madog.renderUI(identifier: identifier, tokenData: .single(1), in: Window()))
    }

    func testMultiTokenFactory() {
        typealias TD = MultiUITokenData<Int>
        typealias VC = MultiTokenVC
        class TestContainer: ContainerUI<Int, TD, VC> {}
        class TestFactory: ContainerUIFactory {
            func createContainer() -> ContainerUI<Int, TD, VC> {
                TestContainer(containerViewController: .init())
            }
        }

        let identifier = ContainerUI<Int, TD, VC>.Identifier("testMultiTokenFactory")
        XCTAssertTrue(madog.addContainerUIFactory(identifier: identifier, factory: TestFactory()))
        XCTAssertNotNil(madog.renderUI(identifier: identifier, tokenData: .multi(1, 2, 3), in: Window()))
    }

    func testSplitSingleTokenFactory() {
        typealias TD = SplitSingleUITokenData<Int>
        typealias VC = SplitTokenVC
        class TestContainer: ContainerUI<Int, TD, VC> {}
        class TestFactory: ContainerUIFactory {
            func createContainer() -> ContainerUI<Int, TD, VC> {
                TestContainer(containerViewController: .init())
            }
        }

        let identifier = ContainerUI<Int, TD, VC>.Identifier("testSingleTokenFactory")
        XCTAssertTrue(madog.addContainerUIFactory(identifier: identifier, factory: TestFactory()))
        XCTAssertNotNil(madog.renderUI(identifier: identifier, tokenData: .splitSingle(1, 2), in: Window()))
    }

    func testSplitMultiTokenFactory() {
        typealias TD = SplitMultiUITokenData<Int>
        typealias VC = SplitTokenVC
        class TestContainer: ContainerUI<Int, TD, VC> {}
        class TestFactory: ContainerUIFactory {
            func createContainer() -> ContainerUI<Int, TD, VC> {
                TestContainer(containerViewController: .init())
            }
        }

        let identifier = ContainerUI<Int, TD, VC>.Identifier("testMultiTokenFactory")
        XCTAssertTrue(madog.addContainerUIFactory(identifier: identifier, factory: TestFactory()))
        XCTAssertNotNil(madog.renderUI(identifier: identifier, tokenData: .splitMulti(1, [2, 3]), in: Window()))
    }
}

private typealias TestContainerUI<T> = ContainerUI<T, SingleUITokenData<T>, ViewController>

private extension AnyContainer where T == Int {
    func asImpl() throws -> TestContainerUI<Int> {
        let wrapped = try XCTUnwrap(self as? ContainerProxy<Int, SingleUITokenData<T>, ViewController>)
        return try XCTUnwrap(wrapped.wrapped)
    }
}

private extension TestContainerUI {
    func assignDelegate(_ delegate: TestViewControllerDelegate) throws {
        let vc = try XCTUnwrap(containerViewController.children[0] as? TestViewController<Int>)
        vc.delegate = delegate
    }
}

private class DeallocationTracker: TestViewControllerDelegate {
    var deallocations = 0
    func testViewControllerDidDeallocate() {
        deallocations += 1
    }
}
