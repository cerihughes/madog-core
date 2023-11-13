//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

class ContainerUIRepository<T> {
    private let registry: AnyRegistry<T>
    private var singleRegistry = [String: ErasedSingleContainerUIFactory<T>]()
    private var multiRegistry = [String: ErasedMultiContainerUIFactory<T>]()
    private var splitSingleRegistry = [String: ErasedSplitSingleContainerUIFactory<T>]()
    private var splitMultiRegistry = [String: ErasedSplitMultiContainerUIFactory<T>]()

    init(registry: AnyRegistry<T>) {
        self.registry = registry
    }

    func addContainerUIFactory(identifier: String, factory: ErasedSingleContainerUIFactory<T>) -> Bool {
        guard singleRegistry[identifier] == nil else { return false }
        singleRegistry[identifier] = factory
        return true
    }

    func addContainerUIFactory(identifier: String, factory: ErasedMultiContainerUIFactory<T>) -> Bool {
        guard multiRegistry[identifier] == nil else { return false }
        multiRegistry[identifier] = factory
        return true
    }

    func addContainerUIFactory(identifier: String, factory: ErasedSplitSingleContainerUIFactory<T>) -> Bool {
        guard splitSingleRegistry[identifier] == nil else { return false }
        splitSingleRegistry[identifier] = factory
        return true
    }

    func addContainerUIFactory(identifier: String, factory: ErasedSplitMultiContainerUIFactory<T>) -> Bool {
        guard splitMultiRegistry[identifier] == nil else { return false }
        splitMultiRegistry[identifier] = factory
        return true
    }

    func createContainer<VC, TD>(
        identifier: ContainerUI<T, VC>.Identifier<TD>,
        tokenData: TD
    ) -> ContainerUI<T, VC>? where VC: ViewController, TD: TokenData {
        let key = identifier.value
        if let td = tokenData as? SingleUITokenData<T> {
            return singleRegistry[key]?.createContainer(registry: registry, tokenData: td)
        }
        if let td = tokenData as? MultiUITokenData<T> {
            return multiRegistry[key]?.createContainer(registry: registry, tokenData: td)
        }
        if let td = tokenData as? SplitSingleUITokenData<T> {
            return splitSingleRegistry[key]?.createContainer(registry: registry, tokenData: td)
        }
        if let td = tokenData as? SplitMultiUITokenData<T> {
            return splitMultiRegistry[key]?.createContainer(registry: registry, tokenData: td)
        }
        return nil
    }
}
