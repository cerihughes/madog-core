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

public struct MadogUIIdentifier<VC, C, TD, T> where VC: UIViewController, C: Context<T>, TD: TokenData {
    let value: String

    public init(_ value: String) {
        self.value = value
    }
}

// Ideally, the C constraints on the extensions below would be protocol based, as we shouldn't really be exposing the
// BasicUI, NavigationUI, TabBarUI and TabBarNavigationUI types (they shouldn't even be public).
// Preferably, the extensions should constrain to C: ModalContext<T>, C: NavigationUIContext<T>, C: TabBarUIContext<T>
// and C: TabBarNavigationUIContext<T> respectively (the public protocol types), but that means we get "Generic
// parameter 'C' could not be inferred" at the call site.

public extension MadogUIIdentifier
where VC == BasicUIContainerViewController, C == BasicUI<T>, TD == SingleUITokenData<T> {
    static func basic() -> Self { MadogUIIdentifier("basicIdentifier") }
}

public extension MadogUIIdentifier
where VC == UINavigationController, C == NavigationUI<T>, TD == SingleUITokenData<T> {
    static func navigation() -> Self { MadogUIIdentifier("navigationIdentifier") }
}

public extension MadogUIIdentifier where VC == UITabBarController, C == TabBarUI<T>, TD == MultiUITokenData<T> {
    static func tabBar() -> Self { MadogUIIdentifier("tabBarIdentifier") }
}

public extension MadogUIIdentifier
where VC == UITabBarController, C == TabBarNavigationUI<T>, TD == MultiUITokenData<T> {
    static func tabBarNavigation() -> Self { MadogUIIdentifier("tabBarNavigationIdentifier") }
}

#endif
