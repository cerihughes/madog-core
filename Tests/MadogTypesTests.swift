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

    override func setUp() {
        super.setUp()

        registry = Registry()
    }

    override func tearDown() {
        registry = nil

        super.tearDown()
    }

    func testMadogRegistry() {
        let context = TestContext()
        let uuid = registry.add(registryFunction: createFunction(limit: 0))

        XCTAssertNotNil(registry.createViewController(from: 0, context: context))
        XCTAssertNil(registry.createViewController(from: 1, context: context))

        registry.removeRegistryFunction(uuid: uuid)
        XCTAssertNil(registry.createViewController(from: 0, context: context))
    }

    func testMadogResolver() {
        // This mostly tests that the code compiles as expected... Don't need to exercise it much.

        let resolver = TestResolver()
        XCTAssertEqual(resolver.serviceProviderCreationFunctions().count, 1)
        XCTAssertEqual(resolver.viewControllerProviderCreationFunctions().count, 1)
    }
}

// MARK: - Test functions

private func createFunction(limit: Int) -> (Int, Context) -> UIViewController? {
    return { token, _ in
        guard token <= limit else {
            return nil
        }

        let vc = UIViewController()
        vc.title = "function \(limit)"
        return vc
    }
}

private class MadogTypesTests_TestViewControllerProvider: ViewControllerProvider<Int> {
    private var uuid: UUID?

    override func register(with registry: Registry<Int>) {
        uuid = registry.add(registryFunction: createFunction(limit: 0))
    }

    override func unregister(from registry: Registry<Int>) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }
}

private class TestServiceProvider: ServiceProvider {}

private class TestResolver: Resolver<Int> {
    override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<Int>] {
        let viewControllerProvider = { MadogTypesTests_TestViewControllerProvider() }
        return [viewControllerProvider]
    }

    override func serviceProviderCreationFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        let serviceProvider = { context in TestServiceProvider(context: context) }
        return [serviceProvider]
    }
}

private class TestContext: Context {
    func close(animated: Bool, completion: (() -> Void)?) -> Bool { return false }
    func change<VC>(to _: SingleUIIdentifier<VC>, token _: Any, transition _: Transition?) -> Context? where VC: UIViewController { return nil }
    func change<VC>(to _: MultiUIIdentifier<VC>, tokens _: [Any], transition _: Transition?) -> Context? where VC: UIViewController { return nil }
}
