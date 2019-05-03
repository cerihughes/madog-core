//
//  ViewControllerRegistryTests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 03/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import Madog

class ViewControllerRegistryTests: XCTestCase {

    private var registry: ViewControllerRegistry!

    override func setUp() {
        super.setUp()

        registry = ViewControllerRegistry()
    }

    override func tearDown() {
        registry = nil

        super.tearDown()
    }

    func testRegisterFunction() {
        let uuid = registry.add(registryFunction: createFunction(limit: 10))
        XCTAssertNotNil(registry.createViewController(from: 1))

        registry.removeRegistryFunction(uuid: uuid)
        XCTAssertNil(registry.createViewController(from: 1))
    }

    func testRegisterFunction_providingContext() {
        let uuid = registry.add(registryFunction: createFunction(limit: 10))
        XCTAssertNotNil(registry.createViewController(from: 1, context: TestContext()))

        registry.removeRegistryFunction(uuid: uuid)
        XCTAssertNil(registry.createViewController(from: 1, context: TestContext()))
    }

    func testRegisterFunctionWithContext() {
        let uuid = registry.add(registryFunctionWithContext: createFunctionWithContext(limit: 10))
        XCTAssertNotNil(registry.createViewController(from: 1, context: TestContext()))

        registry.removeRegistryFunction(uuid: uuid)
        XCTAssertNil(registry.createViewController(from: 1, context: TestContext()))
    }

    func testRegisterFunctionWithContext_withoutProvidingContext() {
        let uuid = registry.add(registryFunctionWithContext: createFunctionWithContext(limit: 10))
        XCTAssertNil(registry.createViewController(from: 1))

        registry.removeRegistryFunction(uuid: uuid)
        XCTAssertNil(registry.createViewController(from: 1))
    }

    func testRegisterFunctions_oneIsValid() {
        let uuid1 = registry.add(registryFunction: createFunction(limit: 0))
        let uuid2 = registry.add(registryFunction: createFunction(limit: 1))

        let vc = registry.createViewController(from: 1)
        XCTAssertNotNil(vc)
        XCTAssertEqual(vc!.title, "function 1")

        registry.removeRegistryFunction(uuid: uuid2)
        XCTAssertNil(registry.createViewController(from: 1))

        registry.removeRegistryFunction(uuid: uuid1)
        XCTAssertNil(registry.createViewController(from: 1))
    }

    func testRegisterFunctionWithContext_oneIsValid() {
        let uuid1 = registry.add(registryFunctionWithContext: createFunctionWithContext(limit: 0))
        let uuid2 = registry.add(registryFunctionWithContext: createFunctionWithContext(limit: 1))

        let vc = registry.createViewController(from: 1, context: TestContext())
        XCTAssertNotNil(vc)
        XCTAssertEqual(vc!.title, "functionWithContext 1")

        registry.removeRegistryFunction(uuid: uuid2)
        XCTAssertNil(registry.createViewController(from: 1, context: TestContext()))

        registry.removeRegistryFunction(uuid: uuid1)
        XCTAssertNil(registry.createViewController(from: 1, context: TestContext()))
    }

    func testRegisterFunctions_allValid_usesFirstRegistered() {
        let uuid1 = registry.add(registryFunction: createFunction(limit: 0))
        let uuid2 = registry.add(registryFunction: createFunction(limit: 1))

        let vc = registry.createViewController(from: 0)
        XCTAssertNotNil(vc)
        XCTAssertEqual(vc!.title, "function 0")

        registry.removeRegistryFunction(uuid: uuid2)
        XCTAssertNotNil(registry.createViewController(from: 0))

        registry.removeRegistryFunction(uuid: uuid1)
        XCTAssertNil(registry.createViewController(from: 0))
    }

    func testRegisterFunctionsWithContext_allValid_usesFirstRegistered() {
        let uuid1 = registry.add(registryFunctionWithContext: createFunctionWithContext(limit: 0))
        let uuid2 = registry.add(registryFunctionWithContext: createFunctionWithContext(limit: 1))

        let vc = registry.createViewController(from: 0, context: TestContext())
        XCTAssertNotNil(vc)
        XCTAssertEqual(vc!.title, "functionWithContext 0")

        registry.removeRegistryFunction(uuid: uuid2)
        XCTAssertNotNil(registry.createViewController(from: 0, context: TestContext()))

        registry.removeRegistryFunction(uuid: uuid1)
        XCTAssertNil(registry.createViewController(from: 0, context: TestContext()))
    }

    func testRegisterMixedFunctions_functionsWithContextsReturnFirst() {
        let uuid1 = registry.add(registryFunctionWithContext: createFunctionWithContext(limit: 0))
        let uuid2 = registry.add(registryFunction: createFunction(limit: 0))

        var vc = registry.createViewController(from: 0, context: TestContext())
        XCTAssertEqual(vc!.title, "functionWithContext 0")
        registry.removeRegistryFunction(uuid: uuid1)

        vc = registry.createViewController(from: 0, context: TestContext())
        XCTAssertEqual(vc!.title, "function 0")
        registry.removeRegistryFunction(uuid: uuid2)
    }

    func testRegisterMixedFunctions_allValid_usesFirstRegistered() {
        let uuid1 = registry.add(registryFunctionWithContext: createFunctionWithContext(limit: 0))
        let uuid2 = registry.add(registryFunctionWithContext: createFunctionWithContext(limit: 1))
        let uuid3 = registry.add(registryFunction: createFunction(limit: 0))
        let uuid4 = registry.add(registryFunction: createFunction(limit: 1))

        var vc = registry.createViewController(from: 0, context: TestContext())
        XCTAssertEqual(vc!.title, "functionWithContext 0")
        registry.removeRegistryFunction(uuid: uuid1)

        vc = registry.createViewController(from: 0, context: TestContext())
        XCTAssertEqual(vc!.title, "functionWithContext 1")
        registry.removeRegistryFunction(uuid: uuid2)

        vc = registry.createViewController(from: 0, context: TestContext())
        XCTAssertEqual(vc!.title, "function 0")
        registry.removeRegistryFunction(uuid: uuid3)

        vc = registry.createViewController(from: 0, context: TestContext())
        XCTAssertEqual(vc!.title, "function 1")
        registry.removeRegistryFunction(uuid: uuid4)
    }}

private extension ViewControllerRegistryTests {

    // MARK: - Test functions

    func createFunction(limit: Int) -> (Any) -> UIViewController? {
        return { token in
            guard let token = token as? Int,
                token <= limit else {
                    return nil
            }

            let vc = UIViewController()
            vc.title = "function \(limit)"
            return vc
        }
    }

    func createFunctionWithContext(limit: Int) -> (Any, Context) -> UIViewController? {
        return { token, context in
            guard let token = token as? Int,
                token <= limit else {
                    return nil
            }

            let vc = UIViewController()
            vc.title = "functionWithContext \(limit)"
            return vc
        }
    }
}

fileprivate class TestContext: Context {
    func change<VC>(to identifier: SingleUIIdentifier<VC>, token: Any) -> Bool where VC : UIViewController {
        return true
    }

    func change<VC>(to identifier: MultiUIIdentifier<VC>, tokens: [Any]) -> Bool where VC : UIViewController {
        return true
    }
}
