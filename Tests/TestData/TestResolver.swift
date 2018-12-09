import Foundation
import Madog

class TestResolver: Resolver {
    private let testPageCreationFunctions: [PageCreationFunction]
    private let testStateCreationFunctions: [StateCreationFunction]

    init(testPageCreationFunctions: [PageCreationFunction], testStateCreationFunctions: [StateCreationFunction]) {
        self.testPageCreationFunctions = testPageCreationFunctions
        self.testStateCreationFunctions = testStateCreationFunctions
    }

    func pageCreationFunctions() -> [PageCreationFunction] {
        return testPageCreationFunctions
    }

    func stateCreationFunctions() -> [StateCreationFunction] {
        return testStateCreationFunctions
    }
}
