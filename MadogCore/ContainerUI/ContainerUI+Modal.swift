//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

#if canImport(UIKit)

extension ContainerUI: ModalContainer {

    // MARK: - ModalContainer

    // swiftlint:disable function_parameter_count
    public func openModal<VC2, TD2>(
        identifier: ContainerUI<T, TD2, VC2>.Identifier,
        tokenData: TD2,
        presentationStyle: PresentationStyle?,
        transitionStyle: TransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        customisation: CustomisationBlock<VC2>?,
        completion: CompletionBlock?
    ) throws -> AnyModalToken<T> where VC2: ViewController, TD2: TokenData {
        guard let delegate else { throw MadogError<T>.internalError("Delegate not set in \(self)") }
        let container = try delegate.createContainer(
            identifiableToken: .init(identifier: identifier, data: tokenData),
            isModal: true,
            customisation: customisation
        )

        let presentedViewController = container.containerViewController
        containerViewController.madog_presentModally(
            viewController: presentedViewController,
            presentationStyle: presentationStyle,
            transitionStyle: transitionStyle,
            popoverAnchor: popoverAnchor,
            animated: animated,
            completion: completion
        )

        let proxy = container.proxy()
        return presentedViewController.createModalToken(container: proxy)
    }

    // swiftlint:enable function_parameter_count
    public func closeModal(
        token: AnyModalToken<T>,
        animated: Bool,
        completion: CompletionBlock?
    ) throws {
        guard let token = token as? ModalTokenImplementation<T> else {
            throw MadogError<T>.internalError("Token is not correct type (ModalTokenImplementation)")
        }
        try closeContainer(presentedViewController: token.viewController, animated: animated, completion: completion)
    }

    func closeContainer(
        presentedViewController: ViewController,
        animated: Bool = false,
        completion: CompletionBlock? = nil
    ) throws {
        guard let delegate else { throw MadogError<T>.internalError("Delegate not set in \(self)") }
        if let presentedPresentedViewController = presentedViewController.presentedViewController {
            try closeContainer(presentedViewController: presentedPresentedViewController, animated: animated)
        }

        presentedViewController.dismiss(animated: animated, completion: completion)
        delegate.releaseContainer(for: presentedViewController)
    }
}

private extension ViewController {
    func createModalToken<T>(container: AnyContainer<T>) -> AnyModalToken<T> {
        ModalTokenImplementation(viewController: self, container: container)
    }
}

#endif
