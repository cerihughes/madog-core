//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

class ContainerUIRepository<T> {
    private let registry: AnyRegistry<T>
    private var singleRegistry = [String: AnySingleContainerUIFactory<T>]()
    private var multiRegistry = [String: AnyMultiContainerUIFactory<T>]()
    private var splitSingleRegistry = [String: AnySplitSingleContainerUIFactory<T>]()
    private var splitMultiRegistry = [String: AnySplitMultiContainerUIFactory<T>]()

    init(registry: AnyRegistry<T>) {
        self.registry = registry
    }

    func addContainerUIFactory(identifier: String, factory: AnySingleContainerUIFactory<T>) -> Bool {
        guard singleRegistry[identifier] == nil else { return false }
        singleRegistry[identifier] = factory
        return true
    }

    func addContainerUIFactory(identifier: String, factory: AnyMultiContainerUIFactory<T>) -> Bool {
        guard multiRegistry[identifier] == nil else { return false }
        multiRegistry[identifier] = factory
        return true
    }

    func addContainerUIFactory(identifier: String, factory: AnySplitSingleContainerUIFactory<T>) -> Bool {
        guard splitSingleRegistry[identifier] == nil else { return false }
        splitSingleRegistry[identifier] = factory
        return true
    }

    func addContainerUIFactory(identifier: String, factory: AnySplitMultiContainerUIFactory<T>) -> Bool {
        guard splitMultiRegistry[identifier] == nil else { return false }
        splitMultiRegistry[identifier] = factory
        return true
    }

    func createContainer<TD>(identifier: String, tokenData: TD) -> ContainerUI<T>? where TD: TokenData {
        if let td = tokenData as? SingleUITokenData<T> {
            return singleRegistry[identifier]?.createContainer(registry: registry, tokenData: td)
        }
        if let td = tokenData as? MultiUITokenData<T> {
            return multiRegistry[identifier]?.createContainer(registry: registry, tokenData: td)
        }
        if let td = tokenData as? SplitSingleUITokenData<T> {
            return splitSingleRegistry[identifier]?.createContainer(registry: registry, tokenData: td)
        }
        if let td = tokenData as? SplitMultiUITokenData<T> {
            return splitMultiRegistry[identifier]?.createContainer(registry: registry, tokenData: td)
        }
        return nil
    }
}
