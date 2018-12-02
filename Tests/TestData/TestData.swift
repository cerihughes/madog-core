import Foundation
import Madog

class TestPage: Page {
    var registered = false, unregistered = false
    func register<Token>(with registry: ViewControllerRegistry<Token>) {
        registered = true
    }
    func unregister<Token>(from registry: ViewControllerRegistry<Token>) {
        unregistered = true
    }
}

class TestStatefulPage: TestPage, StatefulPage {
    var capturedState: [String:State]? = nil
    func configure(with state: [String:State]) {
        capturedState = state
    }
}

class TestState: State {
    let name = String(describing: TestState.self)
}

class TestPageFactory: PageFactory {
    static var created = false
    static func createPage() -> Page {
        created = true
        return TestPage()
    }
}

class TestStatefulPageFactory: PageFactory {
    static var created = false
    static func createPage() -> Page {
        created = true
        return TestStatefulPage()
    }
}

class TestStateFactory: StateFactory {
    static var created = false
    static func createState() -> State {
        created = true
        return TestState()
    }
}

class TestPageAndState: TestPage, State {
    let name = String(describing: TestState.self)
}


class TestPageAndStateFactory: PageFactory, StateFactory {
    static var createdPage = false
    static func createPage() -> Page {
        createdPage = true
        return TestPage()
    }

    static var createdState = false
    static func createState() -> State {
        createdState = true
        return TestState()
    }
}
