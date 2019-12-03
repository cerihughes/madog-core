//
//  NavigationToken.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol NavigationToken {}

internal class NavigationTokenImplementation: NavigationToken {
	private let viewController: UIViewController

	internal init(viewController: UIViewController) {
		self.viewController = viewController
	}
}
