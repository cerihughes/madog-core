//
//  ViewControllerUIIdentifiers.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import Foundation
import UIKit

public struct MadogUIIdentifier<VC, C, TD, T> where VC: UIViewController, TD: TokenData {
    let value: String

    public init(_ value: String) {
        self.value = value
    }
}

public extension MadogUIIdentifier
where VC == BasicUIContainerViewController, C == AnyModalContext<T>, TD == SingleUITokenData<T> {
    static func basic() -> Self { MadogUIIdentifier("basicIdentifier") }
}

public typealias NavigationUIContext<T> = ModalContext<T> & ForwardBackNavigationContext<T>
public typealias AnyNavigationUIContext<T> = any NavigationUIContext<T>
public extension MadogUIIdentifier
where VC == UINavigationController, C == AnyNavigationUIContext<T>, TD == SingleUITokenData<T> {
    static func navigation() -> Self { MadogUIIdentifier("navigationIdentifier") }
}

public typealias TabBarUIContext<T> = ModalContext<T> & MultiContext<T>
public typealias AnyTabBarUIContext<T> = any TabBarUIContext<T>
public extension MadogUIIdentifier
where VC == UITabBarController, C == AnyTabBarUIContext<T>, TD == MultiUITokenData<T> {
    static func tabBar() -> Self { MadogUIIdentifier("tabBarIdentifier") }
}

public typealias TabBarNavigationUIContext<T> = TabBarUIContext<T> & ForwardBackNavigationContext<T>
public typealias AnyTabBarNavigationUIContext<T> = any TabBarNavigationUIContext<T>
public extension MadogUIIdentifier
where VC == UITabBarController, C == AnyTabBarNavigationUIContext<T>, TD == MultiUITokenData<T> {
    static func tabBarNavigation() -> Self { MadogUIIdentifier("tabBarNavigationIdentifier") }
}

#endif
