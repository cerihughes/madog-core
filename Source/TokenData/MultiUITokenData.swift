//
//  MultiUITokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public class MultiUITokenData: TokenData {
    public let tokens: [Any]

    public init(tokens: [Any]) {
        self.tokens = tokens
    }
}

public extension TokenData {
    static func multi(_ tokens: [Any]) -> MultiUITokenData {
        MultiUITokenData(tokens: tokens)
    }
}
