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

internal let navigationControllerIdentifier = "navigationControllerIdentifier"

public class SingleUIIdentifier<VC: UIViewController> {
	internal let value: String
	internal let customisation: (VC) -> Void

	public init(_ value: String, customisation: @escaping (VC) -> Void) {
		self.value = value
		self.customisation = customisation
	}

	// swiftlint:disable line_length
	public static func createNavigationControllerIdentifier(customisation: @escaping (UINavigationController) -> Void = { _ in }) -> SingleUIIdentifier<UINavigationController> {
		return SingleUIIdentifier<UINavigationController>(navigationControllerIdentifier, customisation: customisation)
	}

	// swiftlint:enable line_length
}

internal let tabBarControllerIdentifier = "tabBarControllerIdentifier"

public class MultiUIIdentifier<VC: UIViewController> {
	internal let value: String
	internal let customisation: (VC) -> Void

	public init(_ value: String, customisation: @escaping (VC) -> Void) {
		self.value = value
		self.customisation = customisation
	}

	// swiftlint:disable line_length
	public static func createTabBarControllerIdentifier(customisation: @escaping (UITabBarController) -> Void = { _ in }) -> MultiUIIdentifier<UITabBarController> {
		return MultiUIIdentifier<UITabBarController>(tabBarControllerIdentifier, customisation: customisation)
	}

	// swiftlint:enable line_length
}

#endif
