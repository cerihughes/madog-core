//
//  Created by Ceri Hughes on 11/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnySplitSingleContext<T> = any SplitSingleContext<T>

public protocol SplitSingleContext<T> {
    associatedtype T

    @discardableResult
    func showDetail(token: T) -> Bool
}

public extension Context {
    var splitSingle: AnySplitSingleContext<T>? {
        castValue as? AnySplitSingleContext<T>
    }
}
