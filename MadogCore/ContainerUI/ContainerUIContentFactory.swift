//
//  Created by Ceri Hughes on 13/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnyContainerUIContentFactory<T> = any ContainerUIContentFactory<T>
public protocol ContainerUIContentFactory<T> {
    associatedtype T
}

typealias AnyInternalContainerUIContentFactory<T> = any InternalContainerUIContentFactory<T>
protocol InternalContainerUIContentFactory<T>: ContainerUIContentFactory {
    func createContentViewController(from token: Token<T>, parent: AnyInternalContainer<T>) -> ViewController?
}

class ContainerUIContentFactoryImplementation<T>: InternalContainerUIContentFactory {
    private let registry: AnyRegistry<T>

    weak var delegate: AnyContainerCreationDelegate<T>?

    init(registry: AnyRegistry<T>) {
        self.registry = registry
    }

    func createContentViewController(from token: Token<T>, parent: AnyInternalContainer<T>) -> ViewController? {
        guard let context = token.createTokenContext(registry: registry) else { return nil }
        context.delegate = delegate
        return context.createContentViewController(parent: parent)
    }
}
