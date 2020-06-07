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
    func openModal<VC: UIViewController>(identifier: MadogUIIdentifier<VC>,
                                         tokenData: TokenData,
                                         from fromViewController: UIViewController?,
                                         presentationStyle: UIModalPresentationStyle?,
                                         transitionStyle: UIModalTransitionStyle?,
                                         popoverAnchor: Any?,
                                         animated: Bool,
                                         customisation: CustomisationBlock<VC>?,
                                         completion: CompletionBlock?) -> ModalToken?
    // swiftlint:enable function_parameter_count

    @discardableResult
    func closeModal(token: ModalToken,
                    animated: Bool,
                    completion: CompletionBlock?) -> Bool
}

public extension ModalContext {
    @discardableResult
    func openModal<VC: UIViewController>(identifier: MadogUIIdentifier<VC>,
                                         tokenData: TokenData,
                                         from fromViewController: UIViewController? = nil,
                                         presentationStyle: UIModalPresentationStyle? = nil,
                                         transitionStyle: UIModalTransitionStyle? = nil,
                                         popoverAnchor: Any? = nil,
                                         animated: Bool,
                                         customisation: CustomisationBlock<VC>? = nil,
                                         completion: CompletionBlock? = nil) -> ModalToken? {
        openModal(identifier: identifier,
                  tokenData: tokenData,
                  from: fromViewController,
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
    var context: Context? { get }
}

internal class ModalTokenImplementation: ModalToken {
    internal let viewController: UIViewController
    weak var context: Context?

    internal init(viewController: UIViewController, context: Context? = nil) {
        self.viewController = viewController
        self.context = context
    }
}
