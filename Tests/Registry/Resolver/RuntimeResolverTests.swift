import XCTest

@testable import Madog

class RuntimeResolverTests: XCTestCase {

    // MARK: CUT
    private var resolver: RuntimeResolver!

    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: RuntimeResolverTests.self)
        resolver = RuntimeResolver(bundle: bundle)
    }

    override func tearDown() {
        resolver = nil
        super.tearDown()
    }

    func testNumberOfPageCreationFunctions() {
        XCTAssertEqual(resolver.pageCreationFunctions().count, 1)
    }

    func testNumberOfStateCreationFunctions() {
        XCTAssertEqual(resolver.stateCreationFunctions().count, 1)
    }
}
