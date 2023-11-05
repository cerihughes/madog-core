//
//  Created by Ceri Hughes on 23/08/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import MadogCore

class MadogTests: XCTestCase {
    private var madog: Madog<String>!

    override func setUp() {
        super.setUp()

        madog = Madog()
        madog.resolve(resolver: TestResolver())
        madog.addContainerFactory(identifier: .test(), factory: TestContainerFactory())
    }

    override func tearDown() {
        madog = nil

        super.tearDown()
    }

    func testMadogKeepsStrongReferenceToCurrentContext() {
        let window = Window()

        weak var context1 = madog.renderUI(identifier: .test(), tokenData: .single("match"), in: window)
        XCTAssertNotNil(context1)

        weak var context2 = madog.renderUI(identifier: .test(), tokenData: .single("match"), in: window)
        XCTAssertNil(context1)
        XCTAssertNotNil(context2)
    }

    func testServiceProviderAccess() {
        madog = Madog()
        XCTAssertEqual(madog.serviceProviders.count, 0)

        madog.resolve(resolver: TestResolver())
        XCTAssertEqual(madog.serviceProviders.count, 1)
    }
}

private class TestResolver: Resolver {
    func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [TestServiceProvider.init(context:)]
    }

    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<String>] {
        [ { TestViewControllerProvider(matchString: "match") } ]
    }
}

private class TestViewControllerProvider: ViewControllerProvider {
    private let matchString: String

    init(matchString: String) {
        self.matchString = matchString
    }

    func createViewController(token: String, context: AnyContext<String>) -> ViewController? {
        if token == matchString {
            return ViewController()
        }

        return nil
    }
}

private class TestServiceProvider: ServiceProvider {
    var name = "TestServiceProvider"

    init(context _: ServiceProviderCreationContext) {}
}
