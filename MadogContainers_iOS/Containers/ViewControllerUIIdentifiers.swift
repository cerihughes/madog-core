//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation
import MadogCore
import UIKit

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

public extension Madog {
    func registerDefaultContainers() {
        _ = addContainerFactory(identifier: .basic(), factory: BasicContainerFactory())
        _ = addContainerFactory(identifier: .navigation(), factory: NavigationContainerFactory())
        _ = addContainerFactory(identifier: .tabBar(), factory: TabBarContainerFactory())
        _ = addContainerFactory(identifier: .tabBarNavigation(), factory: TabBarNavigationContainerFactory())
    }
}
