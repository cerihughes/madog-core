//
//  Context.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public struct Transition {
	public let duration: TimeInterval
	public let options: UIView.AnimationOptions

	public init(duration: TimeInterval, options: UIView.AnimationOptions) {
		self.duration = duration
		self.options = options
	}
}

public protocol Context: AnyObject {
	@discardableResult
	func close(animated: Bool, completion: (() -> Void)?) -> Bool

	@discardableResult
	func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any, transition: Transition?) -> Context?
	@discardableResult
	func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any], transition: Transition?) -> Context?
}

public extension Context {
	@discardableResult
	func close(animated: Bool) -> Bool {
		return close(animated: animated, completion: nil)
	}

	@discardableResult
	func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any) -> Context? {
		return change(to: identifier, token: token, transition: nil)
	}

	@discardableResult
	func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any]) -> Context? {
		return change(to: identifier, tokens: tokens, transition: nil)
	}
}
