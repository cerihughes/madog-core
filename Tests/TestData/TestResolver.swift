import Foundation
import Madog

class TestResolver: PageResolver, StateResolver {
    private let testPageFactories: [PageFactory.Type]
    private let testStateFactories: [StateFactory.Type]

    init(testPageFactories: [PageFactory.Type], testStateFactories: [StateFactory.Type]) {
        self.testPageFactories = testPageFactories
        self.testStateFactories = testStateFactories
    }

    func pageFactories() -> [PageFactory.Type] {
        return testPageFactories
    }

    func stateFactories() -> [StateFactory.Type] {
        return testStateFactories
    }
}
