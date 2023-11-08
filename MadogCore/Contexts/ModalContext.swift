//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import Foundation

public typealias AnyModalContext<T> = any ModalContext<T>

public protocol ModalContext<T> {
    associatedtype T

    // swiftlint:disable function_parameter_count
    @discardableResult
    func openModal<VC, TD>(
        identifier: Container<T>.Identifier<VC, TD>,
        tokenData: TD,
        presentationStyle: PresentationStyle?,
        transitionStyle: TransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        customisation: CustomisationBlock<VC>?,
        completion: CompletionBlock?
    ) -> AnyModalToken<T>? where VC: ViewController, TD: TokenData
    // swiftlint:enable function_parameter_count

    @discardableResult
    func closeModal(token: AnyModalToken<T>, animated: Bool, completion: CompletionBlock?) -> Bool
}

public extension ModalContext {
    @discardableResult
    func openModal<VC, TD>(
        identifier: Container<T>.Identifier<VC, TD>,
        tokenData: TD,
        presentationStyle: PresentationStyle? = nil,
        transitionStyle: TransitionStyle? = nil,
        popoverAnchor: Any? = nil,
        animated: Bool,
        customisation: CustomisationBlock<VC>? = nil,
        completion: CompletionBlock? = nil
    ) -> AnyModalToken<T>? where VC: ViewController, TD: TokenData {
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
    func closeModal(token: AnyModalToken<T>, animated: Bool) -> Bool {
        closeModal(token: token, animated: animated, completion: nil)
    }
}

public typealias AnyModalToken<T> = any ModalToken<T>

public protocol ModalToken<T> {
    associatedtype T

    var context: AnyContext<T> { get }
}

class ModalTokenImplementation<T>: ModalToken {
    let viewController: ViewController
    let context: AnyContext<T>

    init(viewController: ViewController, context: AnyContext<T>) {
        self.viewController = viewController
        self.context = context
    }
}

public extension Context {
    var modal: AnyModalContext<T>? {
        castValue as? AnyModalContext<T>
    }
}

#endif
