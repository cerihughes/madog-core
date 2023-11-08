//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import Foundation

public typealias AnyForwardBackNavigationContext<T> = any ForwardBackNavigationContext<T>

public protocol ForwardBackNavigationContext<T> {
    associatedtype T

    @discardableResult
    func navigateForward(token: T, animated: Bool) -> Bool
    @discardableResult
    func navigateBack(animated: Bool) -> Bool
    @discardableResult
    func navigateBackToRoot(animated: Bool) -> Bool
}

public extension Context {
    var forwardBack: AnyForwardBackNavigationContext<T>? {
        self as? AnyForwardBackNavigationContext<T>
    }
}

#endif
