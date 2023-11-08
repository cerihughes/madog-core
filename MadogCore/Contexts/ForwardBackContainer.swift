//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import Foundation

public typealias AnyForwardBackContainer<T> = any ForwardBackContainer<T>

public protocol ForwardBackContainer<T> {
    associatedtype T

    @discardableResult
    func navigateForward(token: T, animated: Bool) -> Bool
    @discardableResult
    func navigateBack(animated: Bool) -> Bool
    @discardableResult
    func navigateBackToRoot(animated: Bool) -> Bool
}

public extension Container {
    var forwardBack: AnyForwardBackContainer<T>? {
        castValue as? AnyForwardBackContainer<T>
    }
}

#endif
