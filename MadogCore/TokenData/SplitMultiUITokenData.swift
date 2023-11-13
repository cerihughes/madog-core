//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitMultiUITokenData<T>: TokenData {
    public let primaryToken: Token<T>
    public let secondaryTokens: [Token<T>]
}

public extension TokenData {
    static func splitMulti<T>(_ primaryToken: T, _ secondaryTokens: [T]) -> SplitMultiUITokenData<T> {
        .splitMulti(.use(primaryToken), secondaryTokens.map { .use($0) })
    }

    static func splitMulti<T>(_ primaryToken: Token<T>, _ secondaryTokens: [Token<T>]) -> SplitMultiUITokenData<T> {
        SplitMultiUITokenData(primaryToken: primaryToken, secondaryTokens: secondaryTokens)
    }

    static func splitMulti<T>(_ primaryToken: Token<T>, _ secondaryTokens: Token<T>...) -> SplitMultiUITokenData<T> {
        splitMulti(primaryToken, secondaryTokens)
    }
}
