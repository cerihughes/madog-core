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

public struct MadogUIIdentifier<VC: UIViewController> {
    internal let value: String
    internal let type = VC.self

    public init(_ value: String) {
        self.value = value
    }
}

public extension MadogUIIdentifier where VC == BasicUIContainerViewController {
    static let basic = MadogUIIdentifier(basicIdentifier)
}

public extension MadogUIIdentifier where VC == UINavigationController {
    static let navigation = MadogUIIdentifier(navigationIdentifier)
}

public extension MadogUIIdentifier where VC == UITabBarController {
    static let tabBar = MadogUIIdentifier(tabBarIdentifier)
    static let tabBarNavigation = MadogUIIdentifier(tabBarNavigationIdentifier)
}

#endif
