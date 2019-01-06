//
//  RuntimeResolverTests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import Madog

class RuntimeResolverTests: XCTestCase {

    // MARK: CUT
    private var resolver: RuntimeResolver!

    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: RuntimeResolverTests.self)
        resolver = RuntimeResolver(bundle: bundle)
    }

    override func tearDown() {
        resolver = nil
        super.tearDown()
    }

    func testNumberOfVCProviderCreationFunctions() {
        XCTAssertEqual(resolver.viewControllerProviderCreationFunctions().count, 1)
    }

    func testNumberOfResourceProviderCreationFunctions() {
        XCTAssertEqual(resolver.resourceProviderCreationFunctions().count, 1)
    }
}
