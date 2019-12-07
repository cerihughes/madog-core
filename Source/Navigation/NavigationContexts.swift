//
//  NavigationContexts.swift
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
	func close() -> Bool

	@discardableResult
	func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any, transition: Transition?) -> Context?
	@discardableResult
	func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any], transition: Transition?) -> Context?
}

public extension Context {
	@discardableResult
	func change<VC: UIViewController>(to identifier: SingleUIIdentifier<VC>, token: Any) -> Context? {
		return change(to: identifier, token: token, transition: nil)
	}

	@discardableResult
	func change<VC: UIViewController>(to identifier: MultiUIIdentifier<VC>, tokens: [Any]) -> Context? {
		return change(to: identifier, tokens: tokens, transition: nil)
	}
}

public protocol MultiContext {
	var selectedIndex: Int { get set }
}

public protocol ModalContext: AnyObject {
	// swiftlint:disable function_parameter_count
	@discardableResult
	func openModal(token: Any,
				   from fromViewController: UIViewController?,
				   presentationStyle: UIModalPresentationStyle?,
				   transitionStyle: UIModalTransitionStyle?,
				   popoverAnchor: Any?,
				   animated: Bool,
				   completion: (() -> Void)?) -> ModalToken?

	@discardableResult
	func openModal<VC: UIViewController>(identifier: SingleUIIdentifier<VC>,
										 token: Any,
										 from fromViewController: UIViewController?,
										 presentationStyle: UIModalPresentationStyle?,
										 transitionStyle: UIModalTransitionStyle?,
										 popoverAnchor: Any?,
										 animated: Bool,
										 completion: (() -> Void)?) -> ModalToken?

	@discardableResult
	func openModal<VC: UIViewController>(identifier: MultiUIIdentifier<VC>,
										 tokens: [Any],
										 from fromViewController: UIViewController?,
										 presentationStyle: UIModalPresentationStyle?,
										 transitionStyle: UIModalTransitionStyle?,
										 popoverAnchor: Any?,
										 animated: Bool,
										 completion: (() -> Void)?) -> ModalToken?
	// swiftlint:enable function_parameter_count

	@discardableResult
	func closeModal(token: ModalToken,
					animated: Bool,
					completion: (() -> Void)?) -> Bool
}

public extension ModalContext {
	@discardableResult
	func openModal(token: Any,
				   from fromViewController: UIViewController? = nil,
				   presentationStyle: UIModalPresentationStyle? = nil,
				   transitionStyle: UIModalTransitionStyle? = nil,
				   popoverAnchor: Any? = nil,
				   animated: Bool,
				   completion: (() -> Void)? = nil) -> ModalToken? {
		return openModal(token: token,
						 from: fromViewController,
						 presentationStyle: presentationStyle,
						 transitionStyle: transitionStyle,
						 popoverAnchor: popoverAnchor,
						 animated: animated,
						 completion: completion)
	}

	@discardableResult
	func openModal<VC: UIViewController>(identifier: SingleUIIdentifier<VC>,
										 token: Any,
										 from fromViewController: UIViewController? = nil,
										 presentationStyle: UIModalPresentationStyle? = nil,
										 transitionStyle: UIModalTransitionStyle? = nil,
										 popoverAnchor: Any? = nil,
										 animated: Bool,
										 completion: (() -> Void)? = nil) -> ModalToken? {
		return openModal(identifier: identifier,
						 token: token,
						 from: fromViewController,
						 presentationStyle: presentationStyle,
						 transitionStyle: transitionStyle,
						 popoverAnchor: popoverAnchor,
						 animated: animated,
						 completion: completion)
	}

	@discardableResult
	func openModal<VC: UIViewController>(identifier: MultiUIIdentifier<VC>,
										 tokens: [Any],
										 from fromViewController: UIViewController? = nil,
										 presentationStyle: UIModalPresentationStyle? = nil,
										 transitionStyle: UIModalTransitionStyle? = nil,
										 popoverAnchor: Any? = nil,
										 animated: Bool,
										 completion: (() -> Void)? = nil) -> ModalToken? {
		return openModal(identifier: identifier,
						 tokens: tokens,
						 from: fromViewController,
						 presentationStyle: presentationStyle,
						 transitionStyle: transitionStyle,
						 popoverAnchor: popoverAnchor,
						 animated: animated,
						 completion: completion)
	}

	@discardableResult
	func closeModal(token: ModalToken, animated: Bool) -> Bool {
		return closeModal(token: token, animated: animated, completion: nil)
	}
}

public protocol ForwardBackNavigationContext: AnyObject {
	@discardableResult
	func navigateForward(token: Any, animated: Bool) -> Bool
	@discardableResult
	func navigateBack(animated: Bool) -> Bool
	@discardableResult
	func navigateBackToRoot(animated: Bool) -> Bool
}
