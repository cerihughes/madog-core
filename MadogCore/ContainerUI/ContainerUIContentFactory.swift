//
//  Created by Ceri Hughes on 13/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

typealias AnyContainerUIContentFactory<T> = any ContainerUIContentFactory<T>
protocol ContainerUIContentFactory<T> {
    associatedtype T

    func createContentViewController(from token: Token<T>, parent: AnyInternalContainer<T>) -> ViewController?
}

class ContainerUIContentFactoryImplementation<T>: ContainerUIContentFactory {
    private let registry: AnyRegistry<T>

    weak var delegate: AnyContainerCreationDelegate<T>?

    init(registry: AnyRegistry<T>) {
        self.registry = registry
    }

    func createContentViewController(from token: Token<T>, parent: AnyInternalContainer<T>) -> ViewController? {
        guard let delegate else { return nil }
        let context = Token<T>.CreationContext(registry: registry, delegate: delegate, parent: parent)
        return token.createContentViewController(context: context)
    }
}
