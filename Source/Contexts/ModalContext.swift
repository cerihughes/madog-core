//
//  ModalContext.swift
//  Madog
//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias AnyModalContext<T> = any ModalContext<T>

public protocol ModalContext<T>: Context {

    // swiftlint:disable function_parameter_count
    @discardableResult
    func openModal<VC, C, TD>(
        identifier: MadogUIIdentifier<VC, C, TD, T>,
        tokenData: TD,
        presentationStyle: UIModalPresentationStyle?,
        transitionStyle: UIModalTransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        customisation: CustomisationBlock<VC>?,
        completion: CompletionBlock?
    ) -> AnyModalToken<T, C>? where VC: UIViewController, C: Context<T>, TD: TokenData
    // swiftlint:enable function_parameter_count

    @discardableResult
    func closeModal(token: AnyModalToken<T, some Context<T>>, animated: Bool, completion: CompletionBlock?) -> Bool
}

public extension ModalContext {
    @discardableResult
    func openModal<VC, C, TD>(
        identifier: MadogUIIdentifier<VC, C, TD, T>,
        tokenData: TD,
        presentationStyle: UIModalPresentationStyle? = nil,
        transitionStyle: UIModalTransitionStyle? = nil,
        popoverAnchor: Any? = nil,
        animated: Bool,
        customisation: CustomisationBlock<VC>? = nil,
        completion: CompletionBlock? = nil
    ) -> AnyModalToken<T, C>? where VC: UIViewController, C: Context<T>, TD: TokenData {
        openModal(
            identifier: identifier,
            tokenData: tokenData,
            presentationStyle: presentationStyle,
            transitionStyle: transitionStyle,
            popoverAnchor: popoverAnchor,
            animated: animated,
            customisation: customisation,
            completion: completion
        )
    }

    @discardableResult
    func closeModal(token: AnyModalToken<T, some Context<T>>, animated: Bool) -> Bool {
        closeModal(token: token, animated: animated, completion: nil)
    }
}

public typealias AnyModalToken<T, C> = any ModalToken<T, C>

public protocol ModalToken<T, C> where C: Context<T> {
    associatedtype T
    associatedtype C

    var context: C { get }
}

class ModalTokenImplementation<T, C>: ModalToken where C: Context<T> {
    let viewController: UIViewController
    let context: C

    init(viewController: UIViewController, context: C) {
        self.viewController = viewController
        self.context = context
    }
}
