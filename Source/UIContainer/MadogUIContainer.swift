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
	func renderUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>, token: Any, in window: UIWindow, transition: Transition?) -> Context?
	func renderUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>, tokens: [Any], in window: UIWindow, transition: Transition?) -> Context?
}

open class MadogUIContext: Context {
	internal weak var delegate: MadogUIContainerDelegate?
	internal let viewController: UIViewController

	public init(viewController: UIViewController) {
		self.viewController = viewController
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

		let sourceViewController = fromViewController ?? viewController
		sourceViewController.madog_presentModally(viewController: viewController,
												  presentationStyle: presentationStyle,
												  transitionStyle: transitionStyle,
												  popoverAnchor: popoverAnchor,
												  animated: animated,
												  completion: completion)
		return createNavigationToken(for: viewController)
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
