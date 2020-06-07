//
//  SplitSingleUITokenHolder.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public class SplitSingleUITokenHolder<Token>: TokenHolder<Token> {
    public let primaryToken: Token
    public let secondaryToken: Token

    public init(primaryToken: Token, secondaryToken: Token) {
        self.primaryToken = primaryToken
        self.secondaryToken = secondaryToken
    }
}
