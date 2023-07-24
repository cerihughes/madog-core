//
//  Created by Ceri Hughes on 04/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import XCTest

@testable import MadogCore

class MadogTypesTests: XCTestCase {
    private var registry: RegistryImplementation<Int>!
    private var registrar: Registrar<Int>!

    override func setUp() {
        super.setUp()

        registry = RegistryImplementation()
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

private class TestViewControllerProvider: ViewControllerProvider {
    func createViewController(token: Int, context: AnyContext<Int>) -> UIViewController? {
        UIViewController()
    }
}

private class TestServiceProvider: ServiceProvider {
    var name = "TestServiceProvider"

    init(context _: ServiceProviderCreationContext) {}
}

private class TestResolver: Resolver {
    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<Int>] {
        [TestViewControllerProvider.init]
    }

    func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [TestServiceProvider.init(context:)]
    }
}

private class TestContext: Context {
    var presentingContext: AnyContext<Int>? { nil }
    func close(animated: Bool, completion: CompletionBlock?) -> Bool { false }
    func change<VC, C, TD>(
        to identifier: MadogUIIdentifier<VC, C, TD, Int>,
        tokenData: TD,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> C? where VC: UIViewController, TD: TokenData { nil }
}
