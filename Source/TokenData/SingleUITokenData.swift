//
//  SingleUITokenData.swift
//  Madog
//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public class SingleUITokenData<Token>: TokenData {
    public let token: Token

    public init(token: Token) {
        self.token = token
    }
}
