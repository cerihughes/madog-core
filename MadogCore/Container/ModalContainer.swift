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
    func openModal<VC2, TD2>(
        identifier: ContainerUI<T, TD2, VC2>.Identifier,
        tokenData: TD2,
        presentationStyle: PresentationStyle?,
        transitionStyle: TransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        customisation: CustomisationBlock<VC2>?,
        completion: CompletionBlock?
    ) -> ModalToken<T>? where VC2: ViewController, TD2: TokenData
    // swiftlint:enable function_parameter_count

    @discardableResult
    func closeModal(token: ModalToken<T>, animated: Bool, completion: CompletionBlock?) -> Bool
}

public extension ModalContainer {
    @discardableResult
    func openModal<VC2, TD2>(
        identifier: ContainerUI<T, TD2, VC2>.Identifier,
        tokenData: TD2,
        presentationStyle: PresentationStyle? = nil,
        transitionStyle: TransitionStyle? = nil,
        popoverAnchor: Any? = nil,
        animated: Bool,
        customisation: CustomisationBlock<VC2>? = nil,
        completion: CompletionBlock? = nil
    ) -> ModalToken<T>? where VC2: ViewController, TD2: TokenData {
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
    func closeModal(token: ModalToken<T>, animated: Bool) -> Bool {
        closeModal(token: token, animated: animated, completion: nil)
    }
}

public struct ModalToken<T> {
    public let container: AnyContainer<T>
}

public extension Container {
    var modal: AnyModalContainer<T>? {
        castValue as? AnyModalContainer<T>
    }
}

#endif
