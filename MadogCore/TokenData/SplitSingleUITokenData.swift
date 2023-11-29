//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitSingleUITokenData<T>: TokenData {
    public let primaryToken: Token<T>
    public let secondaryToken: Token<T>?
}

public extension TokenData {
    static func splitSingle<T>(_ primaryToken: T, _ secondaryToken: T? = nil) -> SplitSingleUITokenData<T> {
        .splitSingle(.use(primaryToken), secondaryToken.flatMap { .use($0) })
    }

    static func splitSingle<T>(
        _ primaryToken: Token<T>,
        _ secondaryToken: Token<T>? = nil
    ) -> SplitSingleUITokenData<T> {
        SplitSingleUITokenData(primaryToken: primaryToken, secondaryToken: secondaryToken)
    }
}
