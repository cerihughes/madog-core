//
//  MultiUITokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public class MultiUITokenData<Token>: TokenData<Token> {
    public let tokens: [Token]

    public init(tokens: [Token]) {
        self.tokens = tokens
    }
}
