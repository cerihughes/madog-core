//
//  MadogUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias NavigationModalContext = ForwardBackNavigationContext & ModalContext & Context
public typealias NavigationModalMultiContext = NavigationModalContext & MultiContext

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
	private var modalContextUIs = [UIViewController: Context]()

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
						  completion: (() -> Void)?) -> ModalToken? {
		guard let token = token as? Token,
			let presentedViewController = registry.createViewController(from: token, context: self) else {
			return nil
		}

		let presentingViewController = fromViewController ?? viewController
		presentingViewController.madog_presentModally(viewController: presentedViewController,
													  presentationStyle: presentationStyle,
													  transitionStyle: transitionStyle,
													  popoverAnchor: popoverAnchor,
													  animated: animated,
													  completion: completion)
		return createModalToken(viewController: presentedViewController, context: nil)
	}

	public func openModal<VC: UIViewController>(identifier: SingleUIIdentifier<VC>,
												token: Any,
												from fromViewController: UIViewController?,
												presentationStyle: UIModalPresentationStyle?,
												transitionStyle: UIModalTransitionStyle?,
												popoverAnchor: Any?,
												animated: Bool,
												completion: (() -> Void)?) -> ModalToken? {
		guard let delegate = delegate,
			let container = delegate.createUI(identifier: identifier, token: token, isModal: true) else {
			return nil
		}

		let presentingViewController = fromViewController ?? viewController
		let presentedViewController = container.viewController
		presentingViewController.madog_presentModally(viewController: presentedViewController,
													  presentationStyle: presentationStyle,
													  transitionStyle: transitionStyle,
													  popoverAnchor: popoverAnchor,
													  animated: animated,
													  completion: completion)
		return createModalToken(viewController: presentedViewController, context: container)
	}

	public func openModal<VC: UIViewController>(identifier: MultiUIIdentifier<VC>,
												tokens: [Any],
												from fromViewController: UIViewController?,
												presentationStyle: UIModalPresentationStyle?,
												transitionStyle: UIModalTransitionStyle?,
												popoverAnchor: Any?,
												animated: Bool,
												completion: (() -> Void)?) -> ModalToken? {
		guard let delegate = delegate,
			let container = delegate.createUI(identifier: identifier, tokens: tokens, isModal: true) else {
			return nil
		}

		let presentingViewController = fromViewController ?? viewController
		let presentedViewController = container.viewController
		presentingViewController.madog_presentModally(viewController: presentedViewController,
													  presentationStyle: presentationStyle,
													  transitionStyle: transitionStyle,
													  popoverAnchor: popoverAnchor,
													  animated: animated,
													  completion: completion)
		return createModalToken(viewController: presentedViewController, context: container)
	}

	// swiftlint:enable function_parameter_count

	public func closeModal(token: ModalToken,
						   animated: Bool,
						   completion: (() -> Void)?) -> Bool {
		guard let token = token as? ModalTokenImplementation else {
			return false
		}

		return closeModal(presentedViewController: token.viewController, animated: animated)
	}

	private func closeModal(presentedViewController: UIViewController,
							animated: Bool = false,
							completion: (() -> Void)? = nil) -> Bool {
		for child in presentedViewController.children {
			if closeModal(presentedViewController: child) == false {
				return false
			}
		}

		if let presentedPresentedViewController = presentedViewController.presentedViewController {
			if closeModal(presentedViewController: presentedPresentedViewController) == false {
				return false
			}
		}

		presentedViewController.dismiss(animated: animated, completion: completion)
		modalContextUIs[presentedViewController] = nil

		return true
	}

	public final func createModalToken(viewController: UIViewController, context: Context?) -> ModalToken {
		modalContextUIs[viewController] = context
		return ModalTokenImplementation(viewController: viewController, context: context)
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
