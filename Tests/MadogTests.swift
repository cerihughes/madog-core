//
//  MadogTests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 23/08/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import Madog

class MadogTests: XCTestCase {
    private var madog: Madog<String>!

    override func setUp() {
        super.setUp()

        madog = Madog()
        madog.resolve(resolver: TestResolver())
    }

    override func tearDown() {
        madog = nil

        super.tearDown()
    }

    func testMadogKeepsStrongReferenceToCurrentContext() {
        let window = UIWindow()
        let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()

        weak var context1 = madog.renderUI(identifier: identifier, token: "match", in: window)
        XCTAssertNotNil(context1)

        weak var context2 = madog.renderUI(identifier: identifier, token: "match", in: window)
        XCTAssertNil(context1)
        XCTAssertNotNil(context2)
    }

    func testServiceProviderAccess() {
        madog = Madog()
        XCTAssertEqual(madog.serviceProviders.count, 0)

        madog.resolve(resolver: TestResolver())
        XCTAssertEqual(madog.serviceProviders.count, 1)
    }

    func testUnregistration() {
        madog = Madog()
        XCTAssertNil(BaseViewControllerProvider.latestUUID)

        madog.resolve(resolver: TestResolver())
        XCTAssertNotNil(BaseViewControllerProvider.latestUUID)

        madog = nil
        XCTAssertNil(BaseViewControllerProvider.latestUUID)
    }
}

private class TestResolver: Resolver<String> {
    override func serviceProviderCreationFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        return [
            { context in TestServiceProvider(context: context) }
        ]
    }

    override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<String>] {
        return [
            { TestViewControllerProvider(matchString: "match") }
        ]
    }
}

private class TestViewControllerProvider: BaseViewControllerProvider {
    private let matchString: String

    init(matchString: String) {
        self.matchString = matchString
        super.init()
    }

    override func createViewController(token: String, context: Context) -> UIViewController? {
        if token == matchString {
            return UIViewController()
        }

        return super.createViewController(token: token, context: context)
    }
}

private class TestServiceProvider: ServiceProvider {}
