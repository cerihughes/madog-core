//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct MultiUITokenData<T>: TokenData {
    public let tokens: [Token<T>]
}

public extension TokenData {
    static func multi<T>(_ tokens: [T]) -> MultiUITokenData<T> {
        .multi(tokens.map { Token.use($0) })
    }

    static func multi<T>(_ tokens: T...) -> MultiUITokenData<T> {
        multi(tokens)
    }

    static func multi<T>(_ tokens: [Token<T>]) -> MultiUITokenData<T> {
        MultiUITokenData(tokens: tokens)
    }

    static func multi<T>(_ tokens: Token<T>...) -> MultiUITokenData<T> {
        multi(tokens)
    }
}
