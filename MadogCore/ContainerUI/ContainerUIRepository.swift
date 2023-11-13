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
        identifiableToken: IdentifiableToken<T, TD, VC>
    ) -> ContainerUI<T, TD, VC>? where VC: ViewController, TD: TokenData {
        let key = identifiableToken.identifier.value
        if let typed = identifiableToken.typed(SingleUITokenData<T>.self), let factory = singleRegistry[key] {
            return factory.createContainer(registry: registry, identifiableToken: typed) as? ContainerUI<T, TD, VC>
        }
        if let typed = identifiableToken.typed(MultiUITokenData<T>.self), let factory = multiRegistry[key] {
            return factory.createContainer(registry: registry, identifiableToken: typed) as? ContainerUI<T, TD, VC>
        }
        if let typed = identifiableToken.typed(SplitSingleUITokenData<T>.self), let factory = splitSingleRegistry[key] {
            return factory.createContainer(registry: registry, identifiableToken: typed) as? ContainerUI<T, TD, VC>
        }
        if let typed = identifiableToken.typed(SplitMultiUITokenData<T>.self), let factory = splitMultiRegistry[key] {
            return factory.createContainer(registry: registry, identifiableToken: typed) as? ContainerUI<T, TD, VC>
        }
        return nil
    }
}

private extension IdentifiableToken {
    func typed<TD2>(_ type: TD2.Type) -> IdentifiableToken<T, TD2, VC>? {
        guard let identifier = identifier as? ContainerUI<T, TD2, VC>.Identifier, let data = data as? TD2 else {
            return nil
        }
        return .init(identifier: identifier, data: data)
    }
}
