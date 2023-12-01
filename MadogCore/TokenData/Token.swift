//
//  Created by Ceri Hughes on 09/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public class Token<T> {
    struct CreationContext {
        let registry: AnyRegistry<T>
        let delegate: AnyContainerUIDelegate<T>
        let parent: AnyInternalContainer<T>
    }

    func createContentViewController(context: CreationContext) throws -> ViewController {
        throw MadogError<T>.internalError("createContentViewController not overridden in \(self)")
    }
}

public extension Token {
    static func use(_ token: T) -> Token<T> {
        UseParentToken(token: token)
    }

    static func create<VC2>(
        identifier: ContainerUI<T, SingleUITokenData<T>, VC2>.Identifier,
        tokenData: SingleUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> Token<T> where VC2: ViewController {
        ChangeToken(intent: .single(.init(identifier: identifier, data: tokenData)), customisation: customisation)
    }

    static func create<VC2>(
        identifier: ContainerUI<T, MultiUITokenData<T>, VC2>.Identifier,
        tokenData: MultiUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> Token<T> where VC2: ViewController {
        ChangeToken(intent: .multi(.init(identifier: identifier, data: tokenData)), customisation: customisation)
    }

    static func create<VC2>(
        identifier: ContainerUI<T, SplitSingleUITokenData<T>, VC2>.Identifier,
        tokenData: SplitSingleUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> Token<T> where VC2: ViewController {
        ChangeToken(intent: .splitSingle(.init(identifier: identifier, data: tokenData)), customisation: customisation)
    }

    static func create<VC2>(
        identifier: ContainerUI<T, SplitMultiUITokenData<T>, VC2>.Identifier,
        tokenData: SplitMultiUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> Token<T> where VC2: ViewController {
        ChangeToken(intent: .splitMulti(.init(identifier: identifier, data: tokenData)), customisation: customisation)
    }
}

class UseParentToken<T>: Token<T> {
    let token: T

    init(token: T) {
        self.token = token
    }

    override func createContentViewController(context: Token<T>.CreationContext) throws -> ViewController {
        try context.registry.createViewController(token: token, parent: context.parent)
    }
}

class ChangeToken<T, VC>: Token<T> where VC: ViewController {
    let intent: ChangeIntent<T, VC>
    let customisation: CustomisationBlock<VC>?

    init(intent: ChangeIntent<T, VC>, customisation: CustomisationBlock<VC>?) {
        self.intent = intent
        self.customisation = customisation
    }

    override func createContentViewController(context: Token<T>.CreationContext) throws -> ViewController {
        switch intent {
        case .single(let identifiable):
            return try createContainer(identifiableToken: identifiable, context: context)
        case .multi(let identifiable):
            return try createContainer(identifiableToken: identifiable, context: context)
        case .splitSingle(let identifiable):
            return try createContainer(identifiableToken: identifiable, context: context)
        case .splitMulti(let identifiable):
            return try createContainer(identifiableToken: identifiable, context: context)
        }
    }

    private func createContainer<TD>(
        identifiableToken: IdentifiableToken<T, TD, VC>,
        context: Token<T>.CreationContext
    ) throws -> ViewController where TD: TokenData {
        let container = try context.delegate.createContainer(
            identifiableToken: identifiableToken,
            parent: context.parent,
            customisation: customisation)
        return container.containerViewController
    }
}

indirect enum ChangeIntent<T, VC> where VC: ViewController {
    case single(IdentifiableToken<T, SingleUITokenData<T>, VC>)
    case multi(IdentifiableToken<T, MultiUITokenData<T>, VC>)
    case splitSingle(IdentifiableToken<T, SplitSingleUITokenData<T>, VC>)
    case splitMulti(IdentifiableToken<T, SplitMultiUITokenData<T>, VC>)
}
