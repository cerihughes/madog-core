//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

typealias AnyMadogUIContainerDelegate<T> = any MadogUIContainerDelegate<T>

protocol MadogUIContainerDelegate<T>: AnyObject {
    associatedtype T

    func createUI<VC, TD>(
        identifier: MadogUIIdentifier<VC, TD, T>,
        tokenData: TD,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> MadogUIContainer<T>? where VC: ViewController, TD: TokenData

    func context(for viewController: ViewController) -> AnyContext<T>?
    func releaseContext(for viewController: ViewController)
}

open class MadogUIContainer<T>: MadogBaseContainer<T>, Context {

    // MARK: - Context

    public var presentingContext: AnyContext<T>? {
        guard let presentingViewController = viewController.presentingViewController else { return nil }
        return delegate?.context(for: presentingViewController)
    }

    public func close(animated: Bool, completion: CompletionBlock?) -> Bool {
#if canImport(UIKit)
        closeContext(presentedViewController: viewController, animated: animated, completion: completion)
#endif
        return true
    }

    public func change<VC, TD>(
        to identifier: MadogUIIdentifier<VC, TD, T>,
        tokenData: TD,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> AnyContext<T>? where VC: ViewController, TD: TokenData {
        guard
            let container = delegate?.createUI(
                identifier: identifier,
                tokenData: tokenData,
                isModal: false,
                customisation: customisation
            ),
            let window = viewController.view.window
        else { return nil }

        window.setRootViewController(container.viewController, transition: transition)
        return container.wrapped()
    }
}
