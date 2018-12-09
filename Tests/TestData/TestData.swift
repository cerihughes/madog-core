import Foundation
import Madog

class TestPage: PageObject {
    var registered = false, unregistered = false
    var capturedState: [String:State]? = nil
    override func register(with registry: ViewControllerRegistry) {
        registered = true
    }
    override func unregister(from registry: ViewControllerRegistry) {
        unregistered = true
    }
    override func configure(with state: [String:State]) {
        capturedState = state
    }
}

class TestState: StateObject {
    required init() {
        super.init()
        name = String(describing: TestState.self)
    }
}

class TestPageFactory {
    static var created = false
    static func createPage() -> Page {
        created = true
        return TestPage()
    }
}

class TestStateFactory {
    static var created = false
    static func createState() -> State {
        created = true
        return TestState()
    }
}
