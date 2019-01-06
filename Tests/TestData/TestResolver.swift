import Foundation
import Madog

class TestResolver: Resolver {
    private let testViewControllerProviderCreationFunctions: [ViewControllerProviderCreationFunction]
    private let testResourceProviderCreationFunctions: [ResourceProviderCreationFunction]

    init(testViewControllerProviderCreationFunctions: [ViewControllerProviderCreationFunction],
         testResourceProviderCreationFunctions: [ResourceProviderCreationFunction]) {
        self.testViewControllerProviderCreationFunctions = testViewControllerProviderCreationFunctions
        self.testResourceProviderCreationFunctions = testResourceProviderCreationFunctions
    }

    func viewControllerProviderCreationFunctions() -> [ViewControllerProviderCreationFunction] {
        return testViewControllerProviderCreationFunctions
    }

    func resourceProviderCreationFunctions() -> [ResourceProviderCreationFunction] {
        return testResourceProviderCreationFunctions
    }
}
