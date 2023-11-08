//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//
import Foundation

#if canImport(UIKit)

extension MadogUIContainer: ModalContext {

    // MARK: - ModalContext

    // swiftlint:disable function_parameter_count
    public func openModal<VC, TD>(
        identifier: MadogUIIdentifier<VC, TD, T>,
        tokenData: TD,
        presentationStyle: PresentationStyle?,
        transitionStyle: TransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        customisation: CustomisationBlock<VC>?,
        completion: CompletionBlock?
    ) -> AnyModalToken<T>? where VC: ViewController, TD: TokenData {
        guard
            let container = delegate?.createUI(
                identifier: identifier,
                tokenData: tokenData,
                isModal: true,
                customisation: customisation
            )
        else { return nil }

        let presentedViewController = container.viewController
        viewController.madog_presentModally(
            viewController: presentedViewController,
            presentationStyle: presentationStyle,
            transitionStyle: transitionStyle,
            popoverAnchor: popoverAnchor,
            animated: animated,
            completion: completion
        )

        let context = container.wrapped()
        return createModalToken(viewController: presentedViewController, context: context)
    }

    // swiftlint:enable function_parameter_count
    public func closeModal(
        token: AnyModalToken<T>,
        animated: Bool,
        completion: CompletionBlock?
    ) -> Bool {
        guard let token = token as? ModalTokenImplementation<T> else { return false }
        closeContext(presentedViewController: token.viewController, animated: animated, completion: completion)
        return true
    }

    func closeContext(
        presentedViewController: ViewController,
        animated: Bool = false,
        completion: CompletionBlock? = nil
    ) {
        if let presentedPresentedViewController = presentedViewController.presentedViewController {
            closeContext(presentedViewController: presentedPresentedViewController, animated: animated)
        }

        presentedViewController.dismiss(animated: animated, completion: completion)
        delegate?.releaseContext(for: presentedViewController)
    }

    private func createModalToken(viewController: ViewController, context: AnyContext<T>) -> AnyModalToken<T> {
        ModalTokenImplementation(viewController: viewController, context: context)
    }
}

#endif
