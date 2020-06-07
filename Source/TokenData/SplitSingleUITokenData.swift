//
//  SplitSingleUITokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitSingleUITokenData: TokenData {
    public let primaryToken: Any
    public let secondaryToken: Any

    public init<Token>(primaryToken: Token, secondaryToken: Token) {
        self.primaryToken = primaryToken
        self.secondaryToken = secondaryToken
    }
}

public extension TokenData {
    static func splitSingle<Token>(_ primaryToken: Token, _ secondaryToken: Token) -> SplitSingleUITokenData {
        SplitSingleUITokenData(primaryToken: primaryToken, secondaryToken: secondaryToken)
    }
}
