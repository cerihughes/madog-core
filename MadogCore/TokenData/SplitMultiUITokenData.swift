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
    static func splitMulti<T>(
        _ primaryToken: T,
        _ secondaryTokens: [T]
    ) -> Self where Self == SplitMultiUITokenData<T> {
        .splitMulti(.use(primaryToken), secondaryTokens.map { .use($0) })
    }

    static func splitMulti<T>(
        _ primaryToken: Token<T>,
        _ secondaryTokens: [Token<T>]
    ) -> Self where Self == SplitMultiUITokenData<T> {
        SplitMultiUITokenData(primaryToken: primaryToken, secondaryTokens: secondaryTokens)
    }

    static func splitMulti<T>(
        _ primaryToken: Token<T>,
        _ secondaryTokens: Token<T>...
    ) -> Self where Self == SplitMultiUITokenData<T> {
        splitMulti(primaryToken, secondaryTokens)
    }
}

public extension SplitMultiUITokenData {
    func wrapping<VC>(
        identifier: ContainerUI<T, SingleUITokenData<T>, VC>.Identifier,
        customisation: CustomisationBlock<VC>? = nil
    ) -> Self where VC: ViewController {
        .init(
            primaryToken: identifier.wrapping(token: primaryToken, customisation: customisation),
            secondaryTokens: secondaryTokens.map { identifier.wrapping(token: $0, customisation: customisation) }
        )
    }
}
