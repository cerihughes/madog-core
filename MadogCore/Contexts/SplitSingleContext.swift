//
//  Created by Ceri Hughes on 11/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnySplitSingleContext<T> = any SplitSingleContext<T>

public protocol SplitSingleContext<T>: Context {
    @discardableResult
    func showDetail(token: T) -> Bool
}
