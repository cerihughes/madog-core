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
                return thing(identifiableToken: identifiable, isModal: false, customisation: token.customisation)
            case .multi(let identifiable):
                return thing(identifiableToken: identifiable, isModal: false, customisation: token.customisation)
            case .splitSingle(let identifiable):
                return thing(identifiableToken: identifiable, isModal: false, customisation: token.customisation)
            case .splitMulti(let identifiable):
                return thing(identifiableToken: identifiable, isModal: false, customisation: token.customisation)
            }
        }
        return nil
    }

    private func thing<TD, VC>(
        identifiableToken: IdentifiableToken<T, TD, VC>,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> ViewController? where TD: TokenData, VC: ViewController {
        let container = delegate?.createContainer(
            identifiableToken: identifiableToken,
            isModal: isModal,
            customisation: customisation)
        return container?.containerViewController
    }
}
