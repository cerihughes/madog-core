//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import Foundation

public typealias AnyForwardBackContainer<T> = any ForwardBackContainer<T>

public protocol ForwardBackContainer<T> {
    associatedtype T

    func navigateForward(token: Token<T>, animated: Bool) throws
    func navigateBack(animated: Bool) throws
    func navigateBackToRoot(animated: Bool) throws
}

public extension Container {
    var forwardBack: AnyForwardBackContainer<T>? {
        castValue as? AnyForwardBackContainer<T>
    }
}

public extension ForwardBackContainer {
    func navigateForward(token: T, animated: Bool) throws {
        try navigateForward(token: .use(token), animated: animated)
    }
}

#endif
