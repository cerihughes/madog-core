//
//  Created by Ceri Hughes on 11/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnySplitSingleContainer<T> = any SplitSingleContainer<T>

public protocol SplitSingleContainer<T> {
    associatedtype T

    func showDetail(token: Token<T>) throws
}

public extension Container {
    var splitSingle: AnySplitSingleContainer<T>? {
        castValue as? AnySplitSingleContainer<T>
    }
}

public extension SplitSingleContainer {
    func showDetail(token: T) throws {
        try showDetail(token: .use(token))
    }
}
