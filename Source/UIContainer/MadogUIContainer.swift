//
//  MadogUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol MadogUIContainerDelegate: AnyObject {
	func createUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>, token: Any) -> MadogUIContainer?
	func createUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>, tokens: [Any]) -> MadogUIContainer?
}

open class MadogUIContainer: Context {
	internal weak var delegate: MadogUIContainerDelegate?
	internal let viewController: UIViewController

	public init(viewController: UIViewController) {
		self.viewController = viewController
	}

	public func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any, transition: Transition?) -> Context? {
		guard let delegate = delegate,
			let window = viewController.view.window,
			let container = delegate.createUI(identifier: identifier, token: token) else {
			return nil
		}

		window.setRootViewController(viewController, transition: transition)
		return container
	}

	public func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any], transition: Transition?) -> Context? {
		guard let delegate = delegate,
			let window = viewController.view.window,
			let container = delegate.createUI(identifier: identifier, tokens: tokens) else {
			return nil
		}

		window.setRootViewController(viewController, transition: transition)
		return container
	}
}

open class TypedMadogUIContainer<Token>: MadogUIContainer {
	internal var internalRegistry: Registry<Token>!

	public var registry: Registry<Token> {
		return internalRegistry
	}

	// MARK: - ModalContext

	func openModal(token: Any,
				   from fromViewController: UIViewController?,
				   presentationStyle: UIModalPresentationStyle?,
				   transitionStyle: UIModalTransitionStyle?,
				   popoverAnchor: Any?,
				   animated: Bool,
				   completion: (() -> Void)?) -> Bool {
		guard let token = token as? Token,
			let viewController = registry.createViewController(from: token, context: self) else {
			return false
		}

		let sourceViewController = fromViewController ?? viewController
		sourceViewController.madog_presentModally(viewController: viewController,
												  presentationStyle: presentationStyle,
												  transitionStyle: transitionStyle,
												  popoverAnchor: popoverAnchor,
												  animated: animated,
												  completion: completion)
		return true
	}
}

open class MadogSingleUIContainer<Token>: TypedMadogUIContainer<Token> {
	open func renderInitialView(with _: Token) -> Bool {
		return false
	}
}

open class MadogMultiUIContainer<Token>: TypedMadogUIContainer<Token> {
	open func renderInitialViews(with _: [Token]) -> Bool {
		return false
	}
}
