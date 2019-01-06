import Foundation
import Madog

class TestResolver: Resolver {
    private let testPageCreationFunctions: [PageCreationFunction]
    private let testResourceProviderCreationFunctions: [ResourceProviderCreationFunction]

    init(testPageCreationFunctions: [PageCreationFunction], testResourceProviderCreationFunctions: [ResourceProviderCreationFunction]) {
        self.testPageCreationFunctions = testPageCreationFunctions
        self.testResourceProviderCreationFunctions = testResourceProviderCreationFunctions
    }

    func pageCreationFunctions() -> [PageCreationFunction] {
        return testPageCreationFunctions
    }

    func resourceProviderCreationFunctions() -> [ResourceProviderCreationFunction] {
        return testResourceProviderCreationFunctions
    }
}
