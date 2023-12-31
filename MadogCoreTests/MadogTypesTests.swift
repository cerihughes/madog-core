//
//  Created by Ceri Hughes on 04/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import XCTest

@testable import MadogCore

class MadogTypesTests: XCTestCase {
    private var registrar: Registrar<Int>!
    private var registry: AnyRegistry<Int>!

    override func setUp() {
        super.setUp()

        registrar = Registrar()
        registry = registrar.registry
    }

    override func tearDown() {
        registry = nil
        registrar = nil

        super.tearDown()
    }

    func testMadogResolver() {
        // This mostly tests that the code compiles as expected... Don't need to exercise it much.

        let resolver = TestResolver()
        XCTAssertEqual(resolver.serviceProviderFunctions().count, 1)
        XCTAssertEqual(resolver.viewControllerProviderFunctions().count, 1)

        let container = NavigatingContainerUI<Int>(containerViewController: UINavigationController())

        XCTAssertThrowsError(try registry.createViewController(token: 1, parent: container))
        registrar.resolve(resolver: resolver)
        XCTAssertNoThrow(try registry.createViewController(token: 0, parent: container))
    }
}

#endif
