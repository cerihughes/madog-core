//
//  Created by Ceri Hughes on 09/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public class Token<T> {
    public static func use(_ token: T) -> Token<T> {
        UseParentToken(token: token)
    }

    public static func create<VC2>(
        identifier: ContainerUI<T, SingleUITokenData<T>, VC2>.Identifier,
        tokenData: SingleUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> Token<T> where VC2: ViewController {
        ChangeToken(intent: .single(.init(identifier: identifier, data: tokenData)), customisation: customisation)
    }

    public static func create<VC2>(
        identifier: ContainerUI<T, MultiUITokenData<T>, VC2>.Identifier,
        tokenData: MultiUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> Token<T> where VC2: ViewController {
        ChangeToken(intent: .multi(.init(identifier: identifier, data: tokenData)), customisation: customisation)
    }

    public static func create<VC2>(
        identifier: ContainerUI<T, SplitSingleUITokenData<T>, VC2>.Identifier,
        tokenData: SplitSingleUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> Token<T> where VC2: ViewController {
        ChangeToken(intent: .splitSingle(.init(identifier: identifier, data: tokenData)), customisation: customisation)
    }

    public static func create<VC2>(
        identifier: ContainerUI<T, SplitMultiUITokenData<T>, VC2>.Identifier,
        tokenData: SplitMultiUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> Token<T> where VC2: ViewController {
        ChangeToken(intent: .splitMulti(.init(identifier: identifier, data: tokenData)), customisation: customisation)
    }

    func createTokenContext(registry: AnyRegistry<T>) -> AnyTokenContext<T>? {
        nil
    }
}

class UseParentToken<T>: Token<T> {
    let token: T

    init(token: T) {
        self.token = token
    }

    override func createTokenContext(registry: AnyRegistry<T>) -> AnyTokenContext<T>? {
        UseParentTokenContext(registry: registry, token: token)
    }
}

class ChangeToken<T, VC>: Token<T> where VC: ViewController {
    typealias CustomisationBlock = (VC) -> Void

    let intent: ChangeIntent<T, VC>
    let customisation: CustomisationBlock?

    init(intent: ChangeIntent<T, VC>, customisation: CustomisationBlock?) {
        self.intent = intent
        self.customisation = customisation
    }

    override func createTokenContext(registry: AnyRegistry<T>) -> AnyTokenContext<T>? {
        ChangeTokenContext(registry: registry, token: self)
    }
}

indirect enum ChangeIntent<T, VC> where VC: ViewController {
    case single(IdentifiableToken<T, SingleUITokenData<T>, VC>)
    case multi(IdentifiableToken<T, MultiUITokenData<T>, VC>)
    case splitSingle(IdentifiableToken<T, SplitSingleUITokenData<T>, VC>)
    case splitMulti(IdentifiableToken<T, SplitMultiUITokenData<T>, VC>)
}

typealias AnyTokenContext<T> = any TokenContext<T>

protocol TokenContext<T> {
    associatedtype T

    var delegate: AnyContainerCreationDelegate<T>? { get nonmutating set }

    func createContentViewController(parent: AnyInternalContainer<T>) -> ViewController?
}

class UseParentTokenContext<T>: TokenContext {
    private let registry: AnyRegistry<T>
    private let token: T

    weak var delegate: AnyContainerCreationDelegate<T>?

    init(registry: AnyRegistry<T>, token: T) {
        self.registry = registry
        self.token = token
    }

    func createContentViewController(parent: AnyInternalContainer<T>) -> ViewController? {
        registry.createViewController(from: token, parent: parent)
    }
}

class ChangeTokenContext<T, VC>: TokenContext where VC: ViewController {
    private let registry: AnyRegistry<T>
    private let token: ChangeToken<T, VC>

    weak var delegate: AnyContainerCreationDelegate<T>?

    init(registry: AnyRegistry<T>, token: ChangeToken<T, VC>) {
        self.registry = registry
        self.token = token
    }

    func createContentViewController(parent: AnyInternalContainer<T>) -> ViewController? {
        switch token.intent {
        case .single(let identifiable):
            return createContainer(
                identifiableToken: identifiable,
                parent: parent,
                customisation: token.customisation
            )
        case .multi(let identifiable):
            return createContainer(
                identifiableToken: identifiable,
                parent: parent,
                customisation: token.customisation
            )
        case .splitSingle(let identifiable):
            return createContainer(
                identifiableToken: identifiable,
                parent: parent,
                customisation: token.customisation
            )
        case .splitMulti(let identifiable):
            return createContainer(
                identifiableToken: identifiable,
                parent: parent,
                customisation: token.customisation
            )
        }
    }

    private func createContainer<TD2, VC2>(
        identifiableToken: IdentifiableToken<T, TD2, VC2>,
        parent: AnyInternalContainer<T>,
        customisation: CustomisationBlock<VC2>?
    ) -> ViewController? where TD2: TokenData, VC2: ViewController {
        guard let container = delegate?.createContainer(
            identifiableToken: identifiableToken,
            parent: parent,
            customisation: customisation) else {
            return nil
        }
        return container.containerViewController
    }
}
