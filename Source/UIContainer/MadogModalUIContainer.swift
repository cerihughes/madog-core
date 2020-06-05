//
//  MadogModalUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

open class MadogModalUIContainer<Token>: MadogUIContainer, ModalContext {
    internal let registry: Registry<Token>

    public init(registry: Registry<Token>, viewController: UIViewController) {
        self.registry = registry
        super.init(viewController: viewController)
    }

    override public func close(animated: Bool,
                               completion: (() -> Void)?) -> Bool {
        closeContext(presentedViewController: viewController, animated: animated, completion: completion)
        return true
    }

    // MARK: - ModalContext

    // swiftlint:disable function_parameter_count
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
        ModalTokenImplementation(viewController: viewController, context: context)
    }
}
