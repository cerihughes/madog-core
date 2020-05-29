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
    func createUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>, token: Any, isModal: Bool) -> MadogUIContainer?
    func createUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>, tokens: [Any], isModal: Bool) -> MadogUIContainer?

    func releaseContext(for viewController: UIViewController)
}

open class MadogUIContainer: Context {
    internal weak var delegate: MadogUIContainerDelegate?
    internal let viewController: UIViewController

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Context

    public func close(animated: Bool, completion: (() -> Void)?) -> Bool {
        return false
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

open class MadogModalUIContainer<Token>: MadogUIContainer, ModalContext {
    internal var internalRegistry: Registry<Token>!

    public var registry: Registry<Token> {
        return internalRegistry
    }

    public override func close(animated: Bool,
                               completion: (() -> Void)?) -> Bool {
        closeContext(presentedViewController: viewController, animated: animated, completion: completion)
        return true
    }

    open func provideNavigationController() -> UINavigationController? {
        // OVERRIDE
        return nil
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

        closeContext(presentedViewController: token.viewController, animated: animated, completion: completion)
        return true
    }

    private func closeContext(presentedViewController: UIViewController,
                              animated: Bool = false,
                              completion: (() -> Void)? = nil) {
        presentedViewController.children.forEach { closeContext(presentedViewController: $0, animated: animated) }

        if let presentedPresentedViewController = presentedViewController.presentedViewController {
            closeContext(presentedViewController: presentedPresentedViewController, animated: animated)
        }

        presentedViewController.dismiss(animated: animated, completion: completion)
        delegate?.releaseContext(for: presentedViewController)
    }

    public final func createModalToken(viewController: UIViewController, context: Context?) -> ModalToken {
        return ModalTokenImplementation(viewController: viewController, context: context)
    }
}

open class MadogNavigatingModalUIContainer<Token>: MadogModalUIContainer<Token>, ForwardBackNavigationContext {
    // MARK: - ForwardBackNavigationContext

    public func navigateForward(token: Any, animated: Bool) -> Bool {
        guard let token = token as? Token,
            let toViewController = registry.createViewController(from: token, context: self),
            let navigationController = provideNavigationController() else {
            return false
        }

        navigationController.pushViewController(toViewController, animated: animated)
        return true
    }

    public func navigateBack(animated: Bool) -> Bool {
        guard let navigationController = provideNavigationController() else {
            return false
        }

        return navigationController.popViewController(animated: animated) != nil
    }

    public func navigateBackToRoot(animated _: Bool) -> Bool {
        guard let navigationController = provideNavigationController() else {
            return false
        }

        return navigationController.popToRootViewController(animated: true) != nil
    }
}

open class MadogSingleUIContainer<Token>: MadogNavigatingModalUIContainer<Token> {
    open func renderInitialView(with _: Token) -> Bool {
        return false
    }
}

open class MadogMultiUIContainer<Token>: MadogNavigatingModalUIContainer<Token> {
    open func renderInitialViews(with _: [Token]) -> Bool {
        return false
    }
}
