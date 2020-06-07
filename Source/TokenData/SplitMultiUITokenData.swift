//
//  SplitMultiUITokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public class SplitMultiUITokenData<Token>: TokenData<Token> {
    public let primaryToken: Token
    public let secondaryTokens: [Token]

    public init(primaryToken: Token, secondaryTokens: [Token]) {
        self.primaryToken = primaryToken
        self.secondaryTokens = secondaryTokens
    }
}
