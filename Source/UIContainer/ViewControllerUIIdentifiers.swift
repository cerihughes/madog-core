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

public class SingleUIIdentifier<VC: UIViewController> {
    internal let value: String
    internal let customisation: (VC) -> Void

    public init(_ value: String, customisation: @escaping (VC) -> Void) {
        self.value = value
        self.customisation = customisation
    }

    public static func createBasicIdentifier(
        customisation: @escaping (UIViewController) -> Void = { _ in }
    ) -> SingleUIIdentifier<UIViewController> {
        SingleUIIdentifier<UIViewController>(basicIdentifier, customisation: customisation)
    }

    public static func createNavigationIdentifier(
        customisation: @escaping (UINavigationController) -> Void = { _ in }
    ) -> SingleUIIdentifier<UINavigationController> {
        SingleUIIdentifier<UINavigationController>(navigationIdentifier, customisation: customisation)
    }
}

internal let tabBarIdentifier = "tabBarIdentifier"
internal let tabBarNavigationIdentifier = "tabBarNavigationIdentifier"

public class MultiUIIdentifier<VC: UIViewController> {
    internal let value: String
    internal let customisation: (VC) -> Void

    public init(_ value: String, customisation: @escaping (VC) -> Void) {
        self.value = value
        self.customisation = customisation
    }

    public static func createTabBarIdentifier(
        customisation: @escaping (UITabBarController) -> Void = { _ in }
    ) -> MultiUIIdentifier<UITabBarController> {
        MultiUIIdentifier<UITabBarController>(tabBarIdentifier, customisation: customisation)
    }

    public static func createTabBarNavigationIdentifier(
        customisation: @escaping (UITabBarController) -> Void = { _ in }
    ) -> MultiUIIdentifier<UITabBarController> {
        MultiUIIdentifier<UITabBarController>(tabBarNavigationIdentifier, customisation: customisation)
    }
}

#endif
