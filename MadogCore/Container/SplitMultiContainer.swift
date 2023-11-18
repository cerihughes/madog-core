//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnySplitMultiContainer<T> = any SplitMultiContainer<T>

public protocol SplitMultiContainer<T> {
    associatedtype T

    @discardableResult
    func showDetail(tokens: [Token<T>]) -> Bool
}

public extension Container {
    var splitMulti: AnySplitMultiContainer<T>? {
        castValue as? AnySplitMultiContainer<T>
    }
}
