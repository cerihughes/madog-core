//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

class ContainerRepository<T> {
    private let registry: RegistryImplementation<T>
    private var singleRegistry = [String: AnySingleContainerFactory<T>]()
    private var multiRegistry = [String: AnyMultiContainerFactory<T>]()
    private var splitSingleRegistry = [String: AnySplitSingleContainerFactory<T>]()
    private var splitMultiRegistry = [String: AnySplitMultiContainerFactory<T>]()

    init(registry: RegistryImplementation<T>) {
        self.registry = registry
    }

    func addContainerFactory(identifier: String, factory: AnySingleContainerFactory<T>) -> Bool {
        guard singleRegistry[identifier] == nil else { return false }
        singleRegistry[identifier] = factory
        return true
    }

    func addContainerFactory(identifier: String, factory: AnyMultiContainerFactory<T>) -> Bool {
        guard multiRegistry[identifier] == nil else { return false }
        multiRegistry[identifier] = factory
        return true
    }

    func addContainerFactory(identifier: String, factory: AnySplitSingleContainerFactory<T>) -> Bool {
        guard splitSingleRegistry[identifier] == nil else { return false }
        splitSingleRegistry[identifier] = factory
        return true
    }

    func addContainerFactory(identifier: String, factory: AnySplitMultiContainerFactory<T>) -> Bool {
        guard splitMultiRegistry[identifier] == nil else { return false }
        splitMultiRegistry[identifier] = factory
        return true
    }

    func createContainer<TD>(identifier: String, tokenData: TD) -> MadogUIContainer<T>? where TD: TokenData {
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
