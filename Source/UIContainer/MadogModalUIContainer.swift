//
//  MadogModalUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

open class MadogModalUIContainer<Token>: MadogUIContainer, ModalContext {
    public private(set) var registry: Registry<Token>
    public var modalPresentation: ModalPresentation = DefaultModalPresentation()

    public init(registry: Registry<Token>, viewController: UIViewController) {
        self.registry = registry
        super.init(viewController: viewController)
    }

    override public func close(animated: Bool,
                               completion: CompletionBlock?) -> Bool {
        closeContext(presentedViewController: viewController, animated: animated, completion: completion)
        return true
    }

    // MARK: - ModalContext

    // swiftlint:disable function_parameter_count
    public func openModal<VC, TD>(identifier: MadogUIIdentifier<VC, TD>,
                                  tokenData: TD,
                                  from fromViewController: UIViewController?,
                                  presentationStyle: UIModalPresentationStyle?,
                                  transitionStyle: UIModalTransitionStyle?,
                                  popoverAnchor: Any?,
                                  animated: Bool,
                                  customisation: CustomisationBlock<VC>?,
                                  completion: CompletionBlock?) -> ModalToken? where VC: UIViewController, TD: TokenData {
        guard let delegate = delegate,
            let container = delegate.createUI(identifier: identifier, tokenData: tokenData, isModal: true, customisation: customisation) else {
            return nil
        }

        let presentingViewController = fromViewController ?? viewController
        let presentedViewController = container.viewController
        let result = modalPresentation.presentModally(presenting: presentingViewController,
                                                      modal: presentedViewController,
                                                      presentationStyle: presentationStyle,
                                                      transitionStyle: transitionStyle,
                                                      popoverAnchor: popoverAnchor,
                                                      animated: animated,
                                                      completion: completion)
        return result ? createModalToken(viewController: presentedViewController, context: container) : nil
    }

    // swiftlint:enable function_parameter_count

    public func closeModal(token: ModalToken,
                           animated: Bool,
                           completion: CompletionBlock?) -> Bool {
        guard let token = token as? ModalTokenImplementation else {
            return false
        }

        closeContext(presentedViewController: token.viewController, animated: animated, completion: completion)
        return true
    }

    private func closeContext(presentedViewController: UIViewController,
                              animated: Bool = false,
                              completion: CompletionBlock? = nil) {
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
