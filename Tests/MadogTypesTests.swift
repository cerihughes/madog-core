//
//  MadogTypesTests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 04/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import Madog

class MadogTypesTests: XCTestCase {
    private var registry: Registry<Int>!
    private var registrar: Registrar<Int>!

    override func setUp() {
        super.setUp()

        registry = Registry()
        registrar = Registrar(registry: registry)
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

        let context = TestContext()

        XCTAssertNil(registry.createViewController(from: 1, context: context))
        registrar.resolve(resolver: resolver)
        XCTAssertNotNil(registry.createViewController(from: 0, context: context))
    }
}

private class TestViewControllerProvider: SingleViewControllerProvider<Int> {
    override func createViewController(token: Int, context: Context) -> UIViewController? {
        UIViewController()
    }
}

private class TestServiceProvider: ServiceProvider {}

private class TestResolver: Resolver<Int> {
    override func viewControllerProviderFunctions() -> [() -> ViewControllerProvider<Int>] {
        [TestViewControllerProvider.init]
    }

    override func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [TestServiceProvider.init(context:)]
    }
}

private class TestContext: Context {
    func close(animated: Bool, completion: CompletionBlock?) -> Bool { false }
    func change<VC, TD>(to _: MadogUIIdentifier<VC, TD>, tokenData: TD, transition: Transition?, customisation: CustomisationBlock<VC>?) -> Context? { nil }
}
