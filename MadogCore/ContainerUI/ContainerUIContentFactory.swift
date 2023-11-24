//
//  Created by Ceri Hughes on 13/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnyContainerUIContentFactory<T> = any ContainerUIContentFactory<T>
public protocol ContainerUIContentFactory<T> {
    associatedtype T
    func createContentViewController<VC, TD>(
        from token: Token<T>,
        container: ContainerUI<T, TD, VC>
    ) -> ViewController? where TD: TokenData, VC: ViewController
}

class ContainerUIContentFactoryImplementation<T>: ContainerUIContentFactory {
    private let registry: AnyRegistry<T>

    weak var delegate: AnyContainerCreationDelegate<T>?

    init(registry: AnyRegistry<T>) {
        self.registry = registry
    }

    public func createContentViewController<VC, TD>(
        from token: Token<T>,
        container: ContainerUI<T, TD, VC>
    ) -> ViewController? where TD: TokenData, VC: ViewController {
        if let use = token.use {
            return registry.createViewController(from: use, container: container)
        } else if let token = token.changeToken() {
            switch token.intent {
            case .single(let identifiable):
                return createContainer(
                    identifiableToken: identifiable,
                    parent: container,
                    customisation: token.customisation
                )
            case .multi(let identifiable):
                return createContainer(
                    identifiableToken: identifiable,
                    parent: container,
                    customisation: token.customisation
                )
            case .splitSingle(let identifiable):
                return createContainer(
                    identifiableToken: identifiable,
                    parent: container,
                    customisation: token.customisation
                )
            case .splitMulti(let identifiable):
                return createContainer(
                    identifiableToken: identifiable,
                    parent: container,
                    customisation: token.customisation
                )
            }
        }
        return nil
    }

    private func createContainer<TD, VC, TD2, VC2>(
        identifiableToken: IdentifiableToken<T, TD2, VC2>,
        parent: ContainerUI<T, TD, VC>,
        customisation: CustomisationBlock<VC2>?
    ) -> ViewController? where TD: TokenData, TD2: TokenData, VC: ViewController, VC2: ViewController {
        guard let container = delegate?.createContainer(
            identifiableToken: identifiableToken,
            parent: parent,
            customisation: customisation) else {
            return nil
        }
        return container.containerViewController
    }
}
