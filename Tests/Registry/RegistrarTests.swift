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
        let testResourceProviderCreationFunctions: [ResourceProviderCreationFunction] = [TestResourceProviderFactory.createResourceProvider]
        resolver = TestResolver(testViewControllerProviderCreationFunctions: testViewControllerProviderCreationFunctions,
                                testResourceProviderCreationFunctions: testResourceProviderCreationFunctions)
        registry = ViewControllerRegistry()
        registrar = Registrar()
    }

    override func tearDown() {
        registrar = nil
        super.tearDown()
    }

    func testCreateResourceProviders() {
        TestResourceProviderFactory.created = false

        XCTAssertEqual(registrar.resourceProviders.count, 0)
        registrar.createResourceProviders(functions: resolver.resourceProviderCreationFunctions(), context: ResourceProviderCreationContextImplementation())

        // Both factories create a resource provider object with the same name, so we only get 1 object
        XCTAssertEqual(registrar.resourceProviders.count, 1)

        XCTAssertTrue(TestResourceProviderFactory.created)
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
