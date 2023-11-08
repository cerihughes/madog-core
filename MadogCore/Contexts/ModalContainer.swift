//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import Foundation

public typealias AnyModalContainer<T> = any ModalContainer<T>

public protocol ModalContainer<T> {
    associatedtype T

    // swiftlint:disable function_parameter_count
    @discardableResult
    func openModal<VC, TD>(
        identifier: ContainerUI<T>.Identifier<VC, TD>,
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

public extension ModalContainer {
    @discardableResult
    func openModal<VC, TD>(
        identifier: ContainerUI<T>.Identifier<VC, TD>,
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

    var container: AnyContainer<T> { get }
}

class ModalTokenImplementation<T>: ModalToken {
    let viewController: ViewController
    let container: AnyContainer<T>

    init(viewController: ViewController, container: AnyContainer<T>) {
        self.viewController = viewController
        self.container = container
    }
}

public extension Container {
    var modal: AnyModalContainer<T>? {
        castValue as? AnyModalContainer<T>
    }
}

#endif