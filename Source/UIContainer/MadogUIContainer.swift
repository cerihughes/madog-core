//
//  MadogUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias NavigationModalContext = ForwardBackNavigationContext & ModalContext & Context

internal protocol MadogUIContainerDelegate: AnyObject {
	func createUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>, token: Any, isModal: Bool) -> MadogUIContext?
	func createUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>, tokens: [Any], isModal: Bool) -> MadogUIContext?
}

open class MadogUIContext: Context {
	internal weak var delegate: MadogUIContainerDelegate?
	internal let viewController: UIViewController

	public init(viewController: UIViewController) {
		self.viewController = viewController
	}

	public func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any, transition: Transition?) -> Context? {
		guard let delegate = delegate,
			let window = viewController.view.window,
			let container = delegate.createUI(identifier: identifier, token: token, isModal: false) else {
			return nil
		}

		window.setRootViewController(container.viewController, transition: transition)
		return container
	}

	public func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any], transition: Transition?) -> Context? {
		guard let delegate = delegate,
			let window = viewController.view.window,
			let container = delegate.createUI(identifier: identifier, tokens: tokens, isModal: false) else {
			return nil
		}

		window.setRootViewController(container.viewController, transition: transition)
		return container
	}
}

open class MadogUIContainer<Token>: MadogUIContext, ModalContext {
	internal var internalRegistry: Registry<Token>!

	public var registry: Registry<Token> {
		return internalRegistry
	}

	// MARK: - ModalContext

	// swiftlint:disable function_parameter_count
	public func openModal(token: Any,
						  from fromViewController: UIViewController?,
						  presentationStyle: UIModalPresentationStyle?,
						  transitionStyle: UIModalTransitionStyle?,
						  popoverAnchor: Any?,
						  animated: Bool,
						  completion: (() -> Void)?) -> NavigationToken? {
		guard let token = token as? Token,
			let viewController = registry.createViewController(from: token, context: self) else {
			return nil
		}

		let sourceViewController = fromViewController ?? self.viewController
		sourceViewController.madog_presentModally(viewController: viewController,
												  presentationStyle: presentationStyle,
												  transitionStyle: transitionStyle,
												  popoverAnchor: popoverAnchor,
												  animated: animated,
												  completion: completion)
		return createNavigationToken(for: viewController)
	}

	public func openModal<VC: UIViewController>(identifier: SingleUIIdentifier<VC>,
												token: Any,
												from fromViewController: UIViewController?,
												presentationStyle: UIModalPresentationStyle?,
												transitionStyle: UIModalTransitionStyle?,
												popoverAnchor: Any?,
												animated: Bool,
												completion: (() -> Void)?) -> Context? {
		guard let delegate = delegate,
			let container = delegate.createUI(identifier: identifier, token: token, isModal: true) else {
			return nil
		}

		let sourceViewController = fromViewController ?? viewController
		sourceViewController.madog_presentModally(viewController: container.viewController,
												  presentationStyle: presentationStyle,
												  transitionStyle: transitionStyle,
												  popoverAnchor: popoverAnchor,
												  animated: animated,
												  completion: completion)
		return container
	}

	public func openModal<VC: UIViewController>(identifier: MultiUIIdentifier<VC>,
												tokens: [Any],
												from fromViewController: UIViewController?,
												presentationStyle: UIModalPresentationStyle?,
												transitionStyle: UIModalTransitionStyle?,
												popoverAnchor: Any?,
												animated: Bool,
												completion: (() -> Void)?) -> Context? {
		guard let delegate = delegate,
			let container = delegate.createUI(identifier: identifier, tokens: tokens, isModal: true) else {
			return nil
		}

		let sourceViewController = fromViewController ?? viewController
		sourceViewController.madog_presentModally(viewController: container.viewController,
												  presentationStyle: presentationStyle,
												  transitionStyle: transitionStyle,
												  popoverAnchor: popoverAnchor,
												  animated: animated,
												  completion: completion)
		return container
	}

	// swiftlint:enable function_parameter_count

	public final func createNavigationToken(for viewController: UIViewController) -> NavigationToken {
		return NavigationTokenImplementation(viewController: viewController)
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
