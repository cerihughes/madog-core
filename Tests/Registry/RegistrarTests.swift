//
//  RegistrarTests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import Madog

class RegistrarTests: XCTestCase {

    // MARK: CUT
    private var registrar: Registrar!

    // MARK: Test Data
    private var resolver: TestResolver!
    private var registry: ViewControllerRegistry!

    override func setUp() {
        super.setUp()
        let testViewControllerProviderCreationFunctions: [ViewControllerProviderCreationFunction] = [TestViewControllerProviderFactory.createViewControllerProvider]
        let testServiceProviderCreationFunctions: [ServiceProviderCreationFunction] = [TestServiceProviderFactory.createServiceProvider]
        resolver = TestResolver(testViewControllerProviderCreationFunctions: testViewControllerProviderCreationFunctions,
                                testServiceProviderCreationFunctions: testServiceProviderCreationFunctions)
        registry = ViewControllerRegistry()
        registrar = Registrar(registry: registry)
    }

    override func tearDown() {
        registrar = nil
        resolver = nil
        registry = nil
        super.tearDown()
    }

    func testCreateServiceProviders() {
        TestServiceProviderFactory.created = false

        XCTAssertEqual(registrar.serviceProviders.count, 0)
        registrar.createServiceProviders(functions: resolver.serviceProviderCreationFunctions(), context: ServiceProviderCreationContextImplementation())

        // Both factories create a service provider object with the same name, so we only get 1 object
        XCTAssertEqual(registrar.serviceProviders.count, 1)

        XCTAssertTrue(TestServiceProviderFactory.created)
    }

    func testRegisterAndUnregisterViewControllerProviders() {
        TestViewControllerProviderFactory.created = false

        XCTAssertEqual(registrar.viewControllerProviders.count, 0)
        registrar.registerViewControllerProviders(with: registry, functions: resolver.viewControllerProviderCreationFunctions())
        XCTAssertEqual(registrar.viewControllerProviders.count, 1)

        XCTAssertTrue(TestViewControllerProviderFactory.created)

        for viewControllerProvider in registrar.viewControllerProviders {
            let testViewControllerProvider = viewControllerProvider as! TestViewControllerProvider
            XCTAssertTrue(testViewControllerProvider.registered)
            XCTAssertFalse(testViewControllerProvider.unregistered)
        }

        registrar.unregisterViewControllerProviders(from: registry)
        XCTAssertEqual(registrar.viewControllerProviders.count, 0)

        for viewControllerProvider in registrar.viewControllerProviders {
            let testViewControllerProvider = viewControllerProvider as! TestViewControllerProvider
            XCTAssertTrue(testViewControllerProvider.registered)
            XCTAssertTrue(testViewControllerProvider.unregistered)
        }
    }
}
