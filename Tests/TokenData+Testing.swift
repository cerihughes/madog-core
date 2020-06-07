//
//  TokenData+Testing.swift
//  Madog
//
//  Created by Home on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

@testable import Madog

extension String {
    var singleTokenData: SingleUITokenData<Self> {
        SingleUITokenData(token: self)
    }
}

extension Array where Element == String {
    var multiTokenData: MultiUITokenData<Element> {
        MultiUITokenData(tokens: self)
    }
}
