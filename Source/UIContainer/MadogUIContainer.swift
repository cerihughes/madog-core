//
//  MadogUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol MadogUIContainerDelegate: AnyObject {
	func renderUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>, token: Any, in window: UIWindow, transition: Transition?) -> Context?
	func renderUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>, tokens: [Any], in window: UIWindow, transition: Transition?) -> Context?
}

open class MadogUIContainer<Token>: Context {
	internal weak var delegate: MadogUIContainerDelegate?
	internal let viewController: UIViewController
	internal var internalRegistry: Registry<Token>!

	public init(viewController: UIViewController) {
		self.viewController = viewController
	}

	public var registry: Registry<Token> {
		return internalRegistry
	}

	public func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any, transition: Transition?) -> Context? {
		guard let delegate = delegate, let window = viewController.view.window else {
			return nil
		}

		return delegate.renderUI(identifier: identifier, token: token, in: window, transition: transition)
	}

	public func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any], transition: Transition?) -> Context? {
		guard let delegate = delegate, let window = viewController.view.window else {
			return nil
		}

		return delegate.renderUI(identifier: identifier, tokens: tokens, in: window, transition: transition)
	}
}

open class MadogSingleUIContainer<Token>: MadogUIContainer<Token> {
	open func renderInitialView(with _: Token) -> Bool {
		return false
	}
}

open class MadogMultiUIContainer<Token>: MadogUIContainer<Token> {
	open func renderInitialViews(with _: [Token]) -> Bool {
		return false
	}
}
