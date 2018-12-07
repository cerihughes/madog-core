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
    internal let completion: (VC) -> Void

    internal init(_ value: String, completion: @escaping (VC) -> Void) {
        self.value = value
        self.completion = completion
    }

    public static func createNavigationControllerIdentifier(completion: @escaping (UINavigationController) -> Void = { _ in }) -> SinglePageUIIdentifier<UINavigationController> {
        return SinglePageUIIdentifier<UINavigationController>(navigationControllerIdentifier, completion: completion)
    }
}

internal let tabBarControllerIdentifier = "tabBarControllerIdentifier"

public class MultiPageUIIdentifier<VC: UIViewController> {
    internal let value: String
    internal let completion: (VC) -> Void

    internal init(_ value: String, completion: @escaping (VC) -> Void) {
        self.value = value
        self.completion = completion
    }

    public static func createTabBarControllerIdentifier(completion: @escaping (UITabBarController) -> Void = { _ in }) -> MultiPageUIIdentifier<UITabBarController> {
        return MultiPageUIIdentifier<UITabBarController>(tabBarControllerIdentifier, completion: completion)
    }
}
