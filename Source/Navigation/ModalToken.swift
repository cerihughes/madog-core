//
//  ModalToken.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol ModalToken {
	var context: Context? { get }
}

internal class ModalTokenImplementation: ModalToken {
	internal let viewController: UIViewController
	weak var context: Context?

	internal init(viewController: UIViewController, context: Context? = nil) {
		self.viewController = viewController
		self.context = context
	}
}
