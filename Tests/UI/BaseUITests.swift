import XCTest

@testable import Madog

class BaseUITests: XCTestCase {

    // MARK: CUT
    private var baseUI: BaseUI!

    // MARK: Test Data
    private var resolver: TestResolver!
    private var registry: ViewControllerRegistry<String, String>!

    override func setUp() {
        super.setUp()
        let testPageFactories: [PageFactory.Type] = [TestPageFactory.self, TestStatefulPageFactory.self, TestPageAndStateFactory.self]
        let testStateFactories: [StateFactory.Type] = [TestStateFactory.self, TestPageAndStateFactory.self]
        resolver = TestResolver(testPageFactories: testPageFactories, testStateFactories: testStateFactories)
        registry = ViewControllerRegistry<String, String>()
        baseUI = BaseUI()
    }

    override func tearDown() {
        baseUI = nil
        super.tearDown()
    }

    func testLoadState() {
        TestStateFactory.created = false
        TestPageAndStateFactory.createdState = false

        XCTAssertEqual(baseUI.states.count, 0)
        baseUI.loadState(stateResolver: resolver)

        // Both factories create a state object with the same name, so we only get 1 object
        XCTAssertEqual(baseUI.states.count, 1)

        XCTAssertTrue(TestStateFactory.created)
        XCTAssertTrue(TestPageAndStateFactory.createdState)
    }

    func testRegisterAndUnregisterPages() {
        TestPageFactory.created = false
        TestStatefulPageFactory.created = false
        TestPageAndStateFactory.createdPage = false

        XCTAssertEqual(baseUI.pages.count, 0)
        baseUI.registerPages(with: registry, pageResolver: resolver)
        XCTAssertEqual(baseUI.pages.count, 3)

        XCTAssertTrue(TestPageFactory.created)
        XCTAssertTrue(TestStatefulPageFactory.created)
        XCTAssertTrue(TestPageAndStateFactory.createdPage)

        for page in baseUI.pages {
            let testPage = page as! TestPage
            XCTAssertTrue(testPage.registered)
            XCTAssertFalse(testPage.unregistered)
        }

        baseUI.unregisterPages(from: registry)
        XCTAssertEqual(baseUI.pages.count, 0)

        for page in baseUI.pages {
            let testPage = page as! TestPage
            XCTAssertTrue(testPage.registered)
            XCTAssertTrue(testPage.unregistered)
        }
    }
}
