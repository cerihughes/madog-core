//
//  ModalContext.swift
//  Madog
//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol ModalContext: AnyObject {
    // swiftlint:disable function_parameter_count
    @discardableResult
    func openModal<VC, TD>(identifier: MadogUIIdentifier<VC, TD>,
                           tokenData: TD,
                           presentationStyle: UIModalPresentationStyle?,
                           transitionStyle: UIModalTransitionStyle?,
                           popoverAnchor: Any?,
                           animated: Bool,
                           customisation: CustomisationBlock<VC>?,
                           completion: CompletionBlock?) -> ModalToken? where VC: UIViewController, TD: TokenData
    // swiftlint:enable function_parameter_count

    @discardableResult
    func closeModal(token: ModalToken,
                    animated: Bool,
                    completion: CompletionBlock?) -> Bool
}

public extension ModalContext {
    @discardableResult
    func openModal<VC, TD>(identifier: MadogUIIdentifier<VC, TD>,
                           tokenData: TD,
                           presentationStyle: UIModalPresentationStyle? = nil,
                           transitionStyle: UIModalTransitionStyle? = nil,
                           popoverAnchor: Any? = nil,
                           animated: Bool,
                           customisation: CustomisationBlock<VC>? = nil,
                           completion: CompletionBlock? = nil) -> ModalToken? where VC: UIViewController, TD: TokenData {
        openModal(identifier: identifier,
                  tokenData: tokenData,
                  presentationStyle: presentationStyle,
                  transitionStyle: transitionStyle,
                  popoverAnchor: popoverAnchor,
                  animated: animated,
                  customisation: customisation,
                  completion: completion)
    }

    @discardableResult
    func closeModal(token: ModalToken, animated: Bool) -> Bool {
        closeModal(token: token, animated: animated, completion: nil)
    }
}

public protocol ModalToken {
    var context: Context { get }
}

internal class ModalTokenImplementation: ModalToken {
    internal let viewController: UIViewController
    let context: Context

    internal init(viewController: UIViewController, context: Context) {
        self.viewController = viewController
        self.context = context
    }
}
