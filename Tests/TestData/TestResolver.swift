import Foundation
import Madog

class TestResolver: Resolver {
    private let testPageFactoryTypes: [PageFactory.Type]
    private let testStateFactoryTypes: [StateFactory.Type]

    init(testPageFactoryTypes: [PageFactory.Type], testStateFactoryTypes: [StateFactory.Type]) {
        self.testPageFactoryTypes = testPageFactoryTypes
        self.testStateFactoryTypes = testStateFactoryTypes
    }

    func pageFactoryTypes() -> [PageFactory.Type] {
        return testPageFactoryTypes
    }

    func stateFactoryTypes() -> [StateFactory.Type] {
        return testStateFactoryTypes
    }
}
