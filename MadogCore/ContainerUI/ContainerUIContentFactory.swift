//
//  Created by Ceri Hughes on 13/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

typealias AnyContainerUIContentFactory<T> = any ContainerUIContentFactory<T>
protocol ContainerUIContentFactory<T> {
    associatedtype T

    func createContentViewController(token: T, container: AnyInternalContainer<T>) throws -> ViewController
}

class ContainerUIContentFactoryImplementation<T>: ContainerUIContentFactory {
    private let registry: AnyRegistry<T>

    init(registry: AnyRegistry<T>) {
        self.registry = registry
    }

    public func createContentViewController(token: T, container: AnyInternalContainer<T>) throws -> ViewController {
        try registry.createViewController(token: token, container: container)
    }
}
