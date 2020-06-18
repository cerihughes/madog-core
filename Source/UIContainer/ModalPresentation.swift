//
//  ModalPresentation.swift
//  Madog
//
//  Created by Ceri Hughes on 18/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import UIKit

// swiftlint:disable function_parameter_count
public protocol ModalPresentation {
    func presentModally(presenting: UIViewController,
                        modal: UIViewController,
                        presentationStyle: UIModalPresentationStyle?,
                        transitionStyle: UIModalTransitionStyle?,
                        popoverAnchor: Any?,
                        animated: Bool,
                        completion: CompletionBlock?) -> Bool
}

internal class DefaultModalPresentation: ModalPresentation {
    func presentModally(presenting: UIViewController,
                        modal: UIViewController,
                        presentationStyle: UIModalPresentationStyle?,
                        transitionStyle: UIModalTransitionStyle?,
                        popoverAnchor: Any?,
                        animated: Bool,
                        completion: CompletionBlock?) -> Bool {
        presenting.madog_presentModally(viewController: modal,
                                        presentationStyle: presentationStyle,
                                        transitionStyle: transitionStyle,
                                        popoverAnchor: popoverAnchor,
                                        animated: animated,
                                        completion: completion)
        return true
    }
}
