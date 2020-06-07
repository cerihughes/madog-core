//
//  SingleUITokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public class SingleUITokenData: TokenData {
    public let token: Any

    public init(token: Any) {
        self.token = token
    }
}

public extension TokenData {
    static func single(_ token: Any) -> SingleUITokenData {
        SingleUITokenData(token: token)
    }
}
