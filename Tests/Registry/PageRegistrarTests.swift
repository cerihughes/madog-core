import XCTest

@testable import Madog

class PageRegistrarTests: XCTestCase {

    // MARK: CUT
    private var pageRegistrar: PageRegistrar<String>!

    // MARK: Test Data
    private var resolver: TestResolver!
    private var registry: ViewControllerRegistry<String>!

    override func setUp() {
        super.setUp()
        let testPageFactories: [PageFactory.Type] = [TestPageFactory.self, TestStatefulPageFactory.self, TestPageAndStateFactory.self]
        let testStateFactories: [StateFactory.Type] = [TestStateFactory.self, TestPageAndStateFactory.self]
        resolver = TestResolver(testPageFactories: testPageFactories, testStateFactories: testStateFactories)
        registry = ViewControllerRegistry<String>()
        pageRegistrar = PageRegistrar()
    }

    override func tearDown() {
        pageRegistrar = nil
        super.tearDown()
    }

    func testLoadState() {
        TestStateFactory.created = false
        TestPageAndStateFactory.createdState = false

        XCTAssertEqual(pageRegistrar.states.count, 0)
        pageRegistrar.loadState(stateResolver: resolver)

        // Both factories create a state object with the same name, so we only get 1 object
        XCTAssertEqual(pageRegistrar.states.count, 1)

        XCTAssertTrue(TestStateFactory.created)
        XCTAssertTrue(TestPageAndStateFactory.createdState)
    }

    func testRegisterAndUnregisterPages() {
        TestPageFactory.created = false
        TestStatefulPageFactory.created = false
        TestPageAndStateFactory.createdPage = false

        XCTAssertEqual(pageRegistrar.pages.count, 0)
        pageRegistrar.registerPages(with: registry, pageResolver: resolver)
        XCTAssertEqual(pageRegistrar.pages.count, 3)

        XCTAssertTrue(TestPageFactory.created)
        XCTAssertTrue(TestStatefulPageFactory.created)
        XCTAssertTrue(TestPageAndStateFactory.createdPage)

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
