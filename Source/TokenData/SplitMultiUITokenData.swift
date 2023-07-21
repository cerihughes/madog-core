//
//  SplitMultiUITokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitMultiUITokenData<T>: TokenData {
    let primaryToken: T
    let secondaryTokens: [T]
}

public extension TokenData {
    static func splitMulti<T>(_ primaryToken: T, _ secondaryTokens: [T]) -> SplitMultiUITokenData<T> {
        SplitMultiUITokenData(primaryToken: primaryToken, secondaryTokens: secondaryTokens)
    }
}
