import Foundation
import Madog

class TestPage: PageObject {
    var registered = false, unregistered = false
    var capturedResourceProviders: [String : ResourceProvider]? = nil
    override func register(with registry: ViewControllerRegistry) {
        registered = true
    }
    override func unregister(from registry: ViewControllerRegistry) {
        unregistered = true
    }
    override func configure(with resourceProviders: [String : ResourceProvider]) {
        capturedResourceProviders = resourceProviders
    }
}

class TestResourceProvider: ResourceProviderObject {
    required init(context: ResourceProviderCreationContext) {
        super.init(context: context)
        name = String(describing: TestResourceProvider.self)
    }
}

class TestPageFactory {
    static var created = false
    static func createPage() -> Page {
        created = true
        return TestPage()
    }
}

class TestResourceProviderFactory {
    static var created = false
    static func createResourceProvider(context: ResourceProviderCreationContext) -> ResourceProvider {
        created = true
        return TestResourceProvider(context: context)
    }
}
