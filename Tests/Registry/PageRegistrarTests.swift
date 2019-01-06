import XCTest

@testable import Madog

class PageRegistrarTests: XCTestCase {

    // MARK: CUT
    private var pageRegistrar: PageRegistrar!

    // MARK: Test Data
    private var resolver: TestResolver!
    private var registry: ViewControllerRegistry!

    override func setUp() {
        super.setUp()
        let testPageCreationFunctions: [PageCreationFunction] = [TestPageFactory.createPage]
        let testResourceProviderCreationFunctions: [ResourceProviderCreationFunction] = [TestResourceProviderFactory.createResourceProvider]
        resolver = TestResolver(testPageCreationFunctions: testPageCreationFunctions,
                                testResourceProviderCreationFunctions: testResourceProviderCreationFunctions)
        registry = ViewControllerRegistry()
        pageRegistrar = PageRegistrar()
    }

    override func tearDown() {
        pageRegistrar = nil
        super.tearDown()
    }

    func testCreateResourceProviders() {
        TestResourceProviderFactory.created = false

        XCTAssertEqual(pageRegistrar.resourceProviders.count, 0)
        pageRegistrar.createResourceProviders(functions: resolver.resourceProviderCreationFunctions(), context: ResourceProviderCreationContextImplementation())

        // Both factories create a resource provider object with the same name, so we only get 1 object
        XCTAssertEqual(pageRegistrar.resourceProviders.count, 1)

        XCTAssertTrue(TestResourceProviderFactory.created)
    }

    func testRegisterAndUnregisterPages() {
        TestPageFactory.created = false

        XCTAssertEqual(pageRegistrar.pages.count, 0)
        pageRegistrar.registerPages(with: registry, functions: resolver.pageCreationFunctions())
        XCTAssertEqual(pageRegistrar.pages.count, 1)

        XCTAssertTrue(TestPageFactory.created)

        for page in pageRegistrar.pages {
            let testPage = page as! TestPage
            XCTAssertTrue(testPage.registered)
            XCTAssertFalse(testPage.unregistered)
        }

        pageRegistrar.unregisterPages(from: registry)
        XCTAssertEqual(pageRegistrar.pages.count, 0)

        for page in pageRegistrar.pages {
            let testPage = page as! TestPage
            XCTAssertTrue(testPage.registered)
            XCTAssertTrue(testPage.unregistered)
        }
    }
}
