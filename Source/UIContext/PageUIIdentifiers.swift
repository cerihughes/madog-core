//
//  PageUIIdentifiers.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

internal let navigationControllerIdentifier = "navigationControllerIdentifier"

public class SinglePageUIIdentifier<VC: UIViewController> {
    internal let value: String
    internal let customisation: (VC) -> Void

    internal init(_ value: String, customisation: @escaping (VC) -> Void) {
        self.value = value
        self.customisation = customisation
    }

    public static func createNavigationControllerIdentifier(customisation: @escaping (UINavigationController) -> Void = { _ in }) -> SinglePageUIIdentifier<UINavigationController> {
        return SinglePageUIIdentifier<UINavigationController>(navigationControllerIdentifier, customisation: customisation)
    }
}

internal let tabBarControllerIdentifier = "tabBarControllerIdentifier"

public class MultiPageUIIdentifier<VC: UIViewController> {
    internal let value: String
    internal let customisation: (VC) -> Void

    internal init(_ value: String, customisation: @escaping (VC) -> Void) {
        self.value = value
        self.customisation = customisation
    }

    public static func createTabBarControllerIdentifier(customisation: @escaping (UITabBarController) -> Void = { _ in }) -> MultiPageUIIdentifier<UITabBarController> {
        return MultiPageUIIdentifier<UITabBarController>(tabBarControllerIdentifier, customisation: customisation)
    }
}
