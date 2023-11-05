//
//  Created by Ceri Hughes on 18/11/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import UIKit

// swiftlint:disable function_parameter_count
extension ViewController {
    func madog_presentModally(
        viewController: ViewController,
        presentationStyle: PresentationStyle?,
        transitionStyle: TransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        completion: CompletionBlock?
    ) {
        if let presentationStyle {
            viewController.modalPresentationStyle = presentationStyle
        }
        if let transitionStyle {
            viewController.modalTransitionStyle = transitionStyle
        }
        if let popoverAnchor {
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
// swiftlint:enable function_parameter_count

#endif
