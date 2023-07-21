//
//  ForwardBackNavigationContext.swift
//  Madog
//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnyForwardBackNavigationContext<T> = any ForwardBackNavigationContext<T>

public protocol ForwardBackNavigationContext<T>: Context {

    @discardableResult
    func navigateForward(token: T, animated: Bool) -> Bool
    @discardableResult
    func navigateBack(animated: Bool) -> Bool
    @discardableResult
    func navigateBackToRoot(animated: Bool) -> Bool
}
