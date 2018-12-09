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
        let testStateCreationFunctions: [StateCreationFunction] = [TestStateFactory.createState]
        resolver = TestResolver(testPageCreationFunctions: testPageCreationFunctions,
                                testStateCreationFunctions: testStateCreationFunctions)
        registry = ViewControllerRegistry()
        pageRegistrar = PageRegistrar(resolver: resolver)
    }

    override func tearDown() {
        pageRegistrar = nil
        super.tearDown()
    }

    func testLoadState() {
        TestStateFactory.created = false

        XCTAssertEqual(pageRegistrar.states.count, 0)
        pageRegistrar.loadState()

        // Both factories create a state object with the same name, so we only get 1 object
        XCTAssertEqual(pageRegistrar.states.count, 1)

        XCTAssertTrue(TestStateFactory.created)
    }

    func testRegisterAndUnregisterPages() {
        TestPageFactory.created = false

        XCTAssertEqual(pageRegistrar.pages.count, 0)
        pageRegistrar.registerPages(with: registry)
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
