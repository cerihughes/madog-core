//
//  UIViewController+MadogModalPresentation.swift
//  Madog
//
//  Created by Ceri Hughes on 18/11/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

// swiftlint:disable function_parameter_count
internal extension UIViewController {
    func madog_presentModally(viewController: UIViewController,
                              presentationStyle: UIModalPresentationStyle?,
                              transitionStyle: UIModalTransitionStyle?,
                              popoverAnchor: Any?,
                              animated: Bool,
                              completion: CompletionBlock?) {
        if let presentationStyle = presentationStyle {
            viewController.modalPresentationStyle = presentationStyle
        }
        if let transitionStyle = transitionStyle {
            viewController.modalTransitionStyle = transitionStyle
        }
        if let popoverAnchor = popoverAnchor {
            if let rect = popoverAnchor as? CGRect {
                viewController.popoverPresentationController?.sourceRect = rect
            } else if let view = popoverAnchor as? UIView {
                viewController.popoverPresentationController?.sourceView = view
            } else if let barButtonItem = popoverAnchor as? UIBarButtonItem {
                viewController.popoverPresentationController?.barButtonItem = barButtonItem
            }
        } else {
            viewController.popoverPresentationController?.sourceView = view
        }

        present(viewController, animated: animated, completion: completion)
    }
}
