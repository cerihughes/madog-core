//
//  SingleUITokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SingleUITokenData<T>: TokenData {
    let token: T
}

public extension TokenData {
    static func single<T>(_ token: T) -> SingleUITokenData<T> {
        SingleUITokenData(token: token)
    }
}
