//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SingleUITokenData<T>: TokenData {
    public let token: Token<T>
}

public extension TokenData {
    static func single<T>(_ token: T) -> SingleUITokenData<T> {
        .single(.use(token))
    }

    static func single<T>(_ token: Token<T>) -> SingleUITokenData<T> {
        SingleUITokenData(token: token)
    }
}
