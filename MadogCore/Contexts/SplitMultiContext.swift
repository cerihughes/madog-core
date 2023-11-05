//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnySplitMultiContext<T> = any SplitMultiContext<T>

public protocol SplitMultiContext<T>: Context {
    @discardableResult
    func showDetail(tokens: [T]) -> Bool
}
