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

internal let basicIdentifier = "basicIdentifier"
internal let navigationIdentifier = "navigationIdentifier"
internal let tabBarIdentifier = "tabBarIdentifier"
internal let tabBarNavigationIdentifier = "tabBarNavigationIdentifier"

public struct MadogUIIdentifier<VC, TD> where VC: UIViewController, TD: TokenData {
    internal let value: String

    public init(_ value: String) {
        self.value = value
    }
}

public extension MadogUIIdentifier where VC == BasicUIContainerViewController, TD == SingleUITokenData {
    static let basic = MadogUIIdentifier(basicIdentifier)
}

public extension MadogUIIdentifier where VC == UINavigationController, TD == SingleUITokenData {
    static let navigation = MadogUIIdentifier(navigationIdentifier)
}

public extension MadogUIIdentifier where VC == UITabBarController, TD == MultiUITokenData {
    static let tabBar = MadogUIIdentifier(tabBarIdentifier)
    static let tabBarNavigation = MadogUIIdentifier(tabBarNavigationIdentifier)
}

#endif
