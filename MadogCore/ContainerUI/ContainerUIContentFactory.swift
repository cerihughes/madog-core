//
//  Created by Ceri Hughes on 13/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnyContainerUIContentFactory<T> = any ContainerUIContentFactory<T>
public protocol ContainerUIContentFactory<T> {
    associatedtype T
    func createContentViewController<VC, TD>(from token: T, container: ContainerUI<T, TD, VC>) -> ViewController?
}

class ContainerUIContentFactoryImplementation<T>: ContainerUIContentFactory {
    private let registry: AnyRegistry<T>

    init(registry: AnyRegistry<T>) {
        self.registry = registry
    }

    public func createContentViewController<VC, TD>(
        from token: T,
        container: ContainerUI<T, TD, VC>
    ) -> ViewController? {
        registry.createViewController(from: token, container: container)
    }
}
