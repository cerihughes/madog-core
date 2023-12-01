//
//  Created by Ceri Hughes on 01/12/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

@testable import MadogCore

extension SingleUITokenData: Equatable where T: Equatable {
    public static func == (lhs: SingleUITokenData<T>, rhs: SingleUITokenData<T>) -> Bool {
        lhs.token == rhs.token
    }
}

extension MultiUITokenData: Equatable where T: Equatable {
    public static func == (lhs: MultiUITokenData<T>, rhs: MultiUITokenData<T>) -> Bool {
        lhs.tokens == rhs.tokens
    }
}

extension SplitSingleUITokenData: Equatable where T: Equatable {
    public static func == (lhs: SplitSingleUITokenData<T>, rhs: SplitSingleUITokenData<T>) -> Bool {
        lhs.primaryToken == rhs.primaryToken && lhs.secondaryToken == rhs.secondaryToken
    }
}

extension SplitMultiUITokenData: Equatable where T: Equatable {
    public static func == (lhs: SplitMultiUITokenData<T>, rhs: SplitMultiUITokenData<T>) -> Bool {
        lhs.primaryToken == rhs.primaryToken && lhs.secondaryTokens == rhs.secondaryTokens
    }
}

extension Token: Equatable where T: Equatable {
    public static func == (lhs: Token<T>, rhs: Token<T>) -> Bool {
        guard let lhs = lhs as? TokenEquality, let rhs = rhs as? TokenEquality else { return false }
        return lhs.isEqual(to: rhs)
    }
}

protocol TokenEquality {
    func isEqual(to other: TokenEquality) -> Bool
}

extension UseParentToken: TokenEquality where T: Equatable {
    func isEqual(to other: TokenEquality) -> Bool {
        guard let other = other as? UseParentToken<T> else { return false }
        return token == other.token
    }
}

extension ChangeToken: TokenEquality where T: Equatable {
    func isEqual(to other: TokenEquality) -> Bool {
        guard let other = other as? ChangeToken<T, VC> else { return false }
        return intent == other.intent
    }
}

extension ChangeIntent: Equatable where T: Equatable {
    public static func == (lhs: ChangeIntent<T, VC>, rhs: ChangeIntent<T, VC>) -> Bool {
        switch (lhs, rhs) {
        case let (.single(t1), .single(t2)):
            return t1 == t2
        case let (.multi(t1), .multi(t2)):
            return t1 == t2
        case let (.splitSingle(t1), .splitSingle(t2)):
            return t1 == t2
        case let (.splitMulti(t1), .splitMulti(t2)):
            return t1 == t2
        default:
            return false
        }
    }
}

extension IdentifiableToken: Equatable where T: Equatable, TD: Equatable {
    public static func == (lhs: IdentifiableToken<T, TD, VC>, rhs: IdentifiableToken<T, TD, VC>) -> Bool {
        lhs.identifier == rhs.identifier && lhs.data == rhs.data
    }
}

extension ContainerUI.Identifier: Equatable where T: Equatable {
    public static func == (lhs: ContainerUI.Identifier, rhs: ContainerUI.Identifier) -> Bool {
        lhs.value == rhs.value
    }
}
