//
//  Created by Ceri Hughes on 18/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

// swiftlint:disable function_parameter_count
protocol ModalPresentation {
    func presentModally(
        presenting: ViewController,
        modal: ViewController,
        presentationStyle: PresentationStyle?,
        transitionStyle: TransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        completion: CompletionBlock?
    ) -> Bool
}

class DefaultModalPresentation: ModalPresentation {
    func presentModally(
        presenting: ViewController,
        modal: ViewController,
        presentationStyle: PresentationStyle?,
        transitionStyle: TransitionStyle?,
        popoverAnchor: Any?,
        animated: Bool,
        completion: CompletionBlock?
    ) -> Bool {
        presenting.madog_presentModally(
            viewController: modal,
            presentationStyle: presentationStyle,
            transitionStyle: transitionStyle,
            popoverAnchor: popoverAnchor,
            animated: animated,
            completion: completion
        )
        return true
    }
}
// swiftlint:enable function_parameter_count
