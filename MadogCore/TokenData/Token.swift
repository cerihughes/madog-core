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
        identifier: ContainerUI<T, VC2>.Identifier<SingleUITokenData<T>>,
        tokenData: SingleUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> Token<T> where VC2: ViewController {
        ChangeToken(intent: .single(identifier.value, tokenData), customisation: wrap(customisation))
    }

    public static func create<VC2>(
        identifier: ContainerUI<T, VC2>.Identifier<MultiUITokenData<T>>,
        tokenData: MultiUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> Token<T> where VC2: ViewController {
        ChangeToken(intent: .multi(identifier.value, tokenData), customisation: wrap(customisation))
    }

    public static func create<VC2>(
        identifier: ContainerUI<T, VC2>.Identifier<SplitSingleUITokenData<T>>,
        tokenData: SplitSingleUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> Token<T> where VC2: ViewController {
        ChangeToken(intent: .splitSingle(identifier.value, tokenData), customisation: wrap(customisation))
    }

    public static func create<VC2>(
        identifier: ContainerUI<T, VC2>.Identifier<SplitMultiUITokenData<T>>,
        tokenData: SplitMultiUITokenData<T>,
        customisation: CustomisationBlock<VC2>? = nil
    ) -> Token<T> where VC2: ViewController {
        ChangeToken(intent: .splitMulti(identifier.value, tokenData), customisation: wrap(customisation))
    }

    static func wrap<VC>(
        _ block: CustomisationBlock<VC>?
    ) -> ChangeToken<T>.CustomisationBlock? where VC: ViewController {
        guard let block else { return nil }
        return {
            guard let vc = $0 as? VC else { return }
            block(vc)
        }
    }
}

class UseParentToken<T>: Token<T> {
    let token: T

    init(token: T) {
        self.token = token
    }
}

class ChangeToken<T>: Token<T> {
    typealias CustomisationBlock = (ViewController) -> Void

    let intent: ChangeIntent<T>
    let customisation: CustomisationBlock?

    init(intent: ChangeIntent<T>, customisation: CustomisationBlock?) {
        self.intent = intent
        self.customisation = customisation
    }
}

indirect enum ChangeIntent<T> {
    case single(String, SingleUITokenData<T>)
    case multi(String, MultiUITokenData<T>)
    case splitSingle(String, SplitSingleUITokenData<T>)
    case splitMulti(String, SplitMultiUITokenData<T>)
}

extension Token {
    private var useParentToken: UseParentToken<T>? {
        self as? UseParentToken<T>
    }

    private var changeToken: ChangeToken<T>? {
        self as? ChangeToken<T>
    }

    var use: T? {
        useParentToken?.token
    }

    var changeIntent: ChangeIntent<T>? {
        changeToken?.intent
    }
}
