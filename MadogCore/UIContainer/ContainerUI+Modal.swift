//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//
import Foundation

#if canImport(UIKit)

extension ContainerUI: ModalContainer {

    // MARK: - ModalContainer

    // swiftlint:disable function_parameter_count
    public func openModal<VC, TD>(
        identifier: Identifier<VC, TD>,
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

        let proxy = container.proxy()
        return createModalToken(viewController: presentedViewController, container: proxy)
    }

    // swiftlint:enable function_parameter_count
    public func closeModal(
        token: AnyModalToken<T>,
        animated: Bool,
        completion: CompletionBlock?
    ) -> Bool {
        guard let token = token as? ModalTokenImplementation<T> else { return false }
        closeContainer(presentedViewController: token.viewController, animated: animated, completion: completion)
        return true
    }

    func closeContainer(
        presentedViewController: ViewController,
        animated: Bool = false,
        completion: CompletionBlock? = nil
    ) {
        if let presentedPresentedViewController = presentedViewController.presentedViewController {
            closeContainer(presentedViewController: presentedPresentedViewController, animated: animated)
        }

        presentedViewController.dismiss(animated: animated, completion: completion)
        delegate?.releaseContainer(for: presentedViewController)
    }

    private func createModalToken(viewController: ViewController, container: AnyContainer<T>) -> AnyModalToken<T> {
        ModalTokenImplementation(viewController: viewController, container: container)
    }
}

#endif
