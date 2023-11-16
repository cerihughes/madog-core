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
}

class UseParentToken<T>: Token<T> {
    let token: T

    init(token: T) {
        self.token = token
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
}

indirect enum ChangeIntent<T, VC> where VC: ViewController {
    case single(IdentifiableToken<T, SingleUITokenData<T>, VC>)
    case multi(IdentifiableToken<T, MultiUITokenData<T>, VC>)
    case splitSingle(IdentifiableToken<T, SplitSingleUITokenData<T>, VC>)
    case splitMulti(IdentifiableToken<T, SplitMultiUITokenData<T>, VC>)
}

extension Token {
    private var useParentToken: UseParentToken<T>? {
        self as? UseParentToken<T>
    }

    func changeToken<VC>() -> ChangeToken<T, VC>? {
        self as? ChangeToken<T, VC>
    }

    var use: T? {
        useParentToken?.token
    }
}
