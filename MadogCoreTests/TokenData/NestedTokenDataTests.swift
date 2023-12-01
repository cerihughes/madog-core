//
//  Created by Ceri Hughes on 01/12/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCoreTestContainers
import XCTest

@testable import MadogCore

final class NestedTokenDataTests: XCTestCase {

    func testNestedSingleTokenData() {
        let tokenData: SingleUITokenData = .single("vc1").wrapping(identifier: .testNavigation())
        let expected: SingleUITokenData = .single(
            .create(identifier: .testNavigation(), tokenData: .single("vc1"))
        )
        XCTAssertEqual(tokenData, expected)
    }

    func testNestedSingleTokenData_wrongToken() {
        let tokenData: SingleUITokenData = .single("vc1").wrapping(identifier: .testNavigation())
        let expected: SingleUITokenData = .single(
            .create(identifier: .testNavigation(), tokenData: .single("vc2"))
        )
        XCTAssertNotEqual(tokenData, expected)
    }

    func testNestedMultiTokenData() {
        let tokenData: MultiUITokenData = .multi("vc1", "vc2").wrapping(identifier: .testNavigation())
        let expected: MultiUITokenData = .multi(
            .create(identifier: .testNavigation(), tokenData: .single("vc1")),
            .create(identifier: .testNavigation(), tokenData: .single("vc2"))
        )
        XCTAssertEqual(tokenData, expected)
    }

    func testNestedMultiTokenData_wrongOrder() {
        let tokenData: MultiUITokenData = .multi("vc1", "vc2").wrapping(identifier: .testNavigation())
        let expected: MultiUITokenData = .multi(
            .create(identifier: .testNavigation(), tokenData: .single("vc2")),
            .create(identifier: .testNavigation(), tokenData: .single("vc1"))
        )
        XCTAssertNotEqual(tokenData, expected)
    }

    func testNestedSplitSingleTokenData() {
        let tokenData: SplitSingleUITokenData = .splitSingle("vc1", "vc2").wrapping(identifier: .testNavigation())
        let expected: SplitSingleUITokenData = .splitSingle(
            .create(identifier: .testNavigation(), tokenData: .single("vc1")),
            .create(identifier: .testNavigation(), tokenData: .single("vc2"))
        )
        XCTAssertEqual(tokenData, expected)
    }

    func testNestedSplitSingleTokenData_noSecondary() {
        let tokenData: SplitSingleUITokenData = .splitSingle("vc1").wrapping(identifier: .testNavigation())
        let expected: SplitSingleUITokenData = .splitSingle(
            .create(identifier: .testNavigation(), tokenData: .single("vc1"))
        )
        XCTAssertEqual(tokenData, expected)
    }

    func testNestedSplitSingleTokenData_wrongSecondary() {
        let tokenData: SplitSingleUITokenData = .splitSingle("vc1", "vc2").wrapping(identifier: .testNavigation())
        let expected: SplitSingleUITokenData = .splitSingle(
            .create(identifier: .testNavigation(), tokenData: .single("vc1"))
        )
        XCTAssertNotEqual(tokenData, expected)
    }

    func testNestedSplitMultiTokenData() {
        let tokenData: SplitMultiUITokenData = .splitMulti("vc1", ["vc2"]).wrapping(identifier: .testNavigation())
        let expected: SplitMultiUITokenData = .splitMulti(
            .create(identifier: .testNavigation(), tokenData: .single("vc1")),
            [ .create(identifier: .testNavigation(), tokenData: .single("vc2")) ]
        )
        XCTAssertEqual(tokenData, expected)
    }

    func testNestedSplitMultiTokenData_noSecondary() {
        let tokenData: SplitMultiUITokenData = .splitMulti("vc1", []).wrapping(identifier: .testNavigation())
        let expected: SplitMultiUITokenData = .splitMulti(
            .create(identifier: .testNavigation(), tokenData: .single("vc1")),
            []
        )
        XCTAssertEqual(tokenData, expected)
    }

    func testNestedSplitMultiTokenData_wrongSecondary() {
        let tokenData: SplitMultiUITokenData = .splitMulti("vc1", ["vc2"]).wrapping(identifier: .testNavigation())
        let expected: SplitMultiUITokenData = .splitMulti(
            .create(identifier: .testNavigation(), tokenData: .single("vc1")),
            [ .create(identifier: .testNavigation(), tokenData: .single("vc3")) ]
        )
        XCTAssertNotEqual(tokenData, expected)
    }
}
