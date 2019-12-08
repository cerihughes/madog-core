//
//  ForwardBackNavigationContext.swift
//  Madog
//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public protocol ForwardBackNavigationContext: AnyObject {
	@discardableResult
	func navigateForward(token: Any, animated: Bool) -> Bool
	@discardableResult
	func navigateBack(animated: Bool) -> Bool
	@discardableResult
	func navigateBackToRoot(animated: Bool) -> Bool
}
