//
//  Madog.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Provident
import UIKit

public protocol MadogDelegate: AnyObject {
	func madogDidCreateViewController(_ viewController: UIViewController, from token: Any)
	func madogDidNotCreateViewControllerFrom(_ token: Any)
}

public final class Madog<Token>: MadogUIContainerDelegate {
	private let registry = Registry<Token>()
	private let registrar: Registrar<Token, Context>
	private let factory: MadogUIContainerFactory<Token>

	private var currentContainer: MadogUIContainer?
	private var modalContainers = [UIViewController: Context]()

	public weak var delegate: MadogDelegate?

	public init() {
		registrar = Registrar(registry: registry)
		factory = MadogUIContainerFactory<Token>(registry: registry)

		registry.delegate = self
	}

	public func resolve(resolver: Resolver<Token>, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
		registrar.resolve(resolver: resolver, launchOptions: launchOptions)
	}

	@discardableResult
	public func addSingleUICreationFunction(identifier: String, function: @escaping () -> MadogSingleUIContainer<Token>) -> Bool {
		return factory.addSingleUICreationFunction(identifier: identifier, function: function)
	}

	@discardableResult
	public func addMultiUICreationFunction(identifier: String, function: @escaping () -> MadogMultiUIContainer<Token>) -> Bool {
		return factory.addMultiUICreationFunction(identifier: identifier, function: function)
	}

	@discardableResult
	public func renderUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>, token: Any, in window: UIWindow, transition: Transition? = nil) -> Context? {
		guard let context = createUI(identifier: identifier, token: token, isModal: false) else {
			return nil
		}
		window.setRootViewController(context.viewController, transition: transition)
		return context
	}

	@discardableResult
	public func renderUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>, tokens: [Any], in window: UIWindow, transition: Transition? = nil) -> Context? {
		guard let context = createUI(identifier: identifier, tokens: tokens, isModal: false) else {
			return nil
		}
		window.setRootViewController(context.viewController, transition: transition)
		return context
	}

	public var currentContext: Context? {
		return currentContainer
	}

	public var serviceProviders: [String: ServiceProvider] {
		return registrar.serviceProviders
	}

	// MARK: - MadogUIContainerDelegate

	func createUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>, token: Any, isModal: Bool) -> MadogUIContainer? {
		guard let token = token as? Token,
			let container = factory.createSingleUI(identifier: identifier),
			container.renderInitialView(with: token) == true else {
			return nil
		}

		container.delegate = self
		persist(container: container, isModal: isModal)

		guard let viewController = container.viewController as? VC else {
			return nil
		}
		identifier.customisation(viewController)
		return container
	}

	func createUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>, tokens: [Any], isModal: Bool) -> MadogUIContainer? {
		guard let tokens = tokens as? [Token],
			let container = factory.createMultiUI(identifier: identifier),
			container.renderInitialViews(with: tokens) == true else {
			return nil
		}

		container.delegate = self
		persist(container: container, isModal: isModal)

		guard let viewController = container.viewController as? VC else {
			return nil
		}
		identifier.customisation(viewController)
		return container
	}

	func releaseContext(for viewController: UIViewController) {
		if viewController == currentContainer?.viewController {
			currentContainer = nil
		} else {
			modalContainers[viewController] = nil
		}
	}

	// MARK: - Private

	private func persist(container: MadogUIContainer, isModal: Bool) {
		if isModal {
			modalContainers[container.viewController] = container
		} else {
			currentContainer = container
			modalContainers = [:] // Clear old modal contexts
		}
	}
}

extension Madog: RegistryDelegate {
	public func registryDidCreateViewController(_ viewController: UIViewController, from token: Any, context _: Any?) {
		delegate?.madogDidCreateViewController(viewController, from: token)
	}

	public func registryDidNotCreateViewControllerFrom(_ token: Any, context _: Any?) {
		delegate?.madogDidNotCreateViewControllerFrom(token)
	}
}

extension UIWindow {
	func setRootViewController(_ viewController: UIViewController, transition: Transition?) {
		rootViewController = viewController

		if let transition = transition {
			UIView.transition(with: self, duration: transition.duration, options: transition.options, animations: {})
		}
	}
}
