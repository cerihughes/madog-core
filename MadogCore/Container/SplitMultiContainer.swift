//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnySplitMultiContainer<T> = any SplitMultiContainer<T>

public protocol SplitMultiContainer<T> {
    associatedtype T

    func showDetail(tokens: [Token<T>]) throws
}

public extension Container {
    var splitMulti: AnySplitMultiContainer<T>? {
        castValue as? AnySplitMultiContainer<T>
    }
}

public extension SplitMultiContainer {
    func showDetail(tokens: [T]) throws {
        try showDetail(tokens: tokens.map { .use($0) })
    }
}
