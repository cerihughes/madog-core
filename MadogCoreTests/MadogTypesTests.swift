//
//  Created by Ceri Hughes on 04/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

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

        let container = NavigatingContainerUI<Int>(viewController: UINavigationController())

        XCTAssertNil(registry.createViewController(from: 1, container: container))
        registrar.resolve(resolver: resolver)
        XCTAssertNotNil(registry.createViewController(from: 0, container: container))
    }
}
