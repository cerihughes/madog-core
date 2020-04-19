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

private class TestViewControllerProvider: ViewControllerProvider<Int> {
    override func createViewController(token: Int, context: Context) -> UIViewController? {
        return UIViewController()
    }
}

private class TestServiceProvider: ServiceProvider {}

private class TestResolver: Resolver<Int> {
    override func viewControllerProviderFunctions() -> [() -> ViewControllerProvider<Int>] {
        return [TestViewControllerProvider.init]
    }

    override func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        return [TestServiceProvider.init(context:)]
    }
}

private class TestContext: Context {
    func close(animated: Bool, completion: (() -> Void)?) -> Bool { return false }
    func change<VC>(to _: SingleUIIdentifier<VC>, token _: Any, transition _: Transition?) -> Context? where VC: UIViewController { return nil }
    func change<VC>(to _: MultiUIIdentifier<VC>, tokens _: [Any], transition _: Transition?) -> Context? where VC: UIViewController { return nil }
}
