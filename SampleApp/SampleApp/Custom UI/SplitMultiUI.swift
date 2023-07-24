//
//  Created by Ceri Hughes on 23/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

typealias SplitMultiUIContext<T> = ModalContext<T> & SplitMultiContext<T>
typealias AnySplitMultiUIContext<T> = any SplitMultiUIContext<T>
extension MadogUIIdentifier
where VC == UISplitViewController, C == AnySplitMultiUIContext<T>, TD == SplitMultiUITokenData<T> {
    static func splitMulti() -> Self { MadogUIIdentifier("splitViewControllerIdentifier") }
}

protocol SplitMultiContext<T>: Context {
    @discardableResult
    func showDetail(tokens: [T]) -> Bool
}

class SplitMultiUI<T>: MadogModalUIContainer<T>, SplitMultiContext {
    private let splitController = UISplitViewController()

    init?(registry: AnyRegistry<T>, primaryToken: T, secondaryTokens: [T]) {
        super.init(registry: registry, viewController: splitController)

        guard let primaryViewController = registry.createViewController(from: primaryToken, context: self) else {
            return nil
        }

        let navigationController = UINavigationController()
        navigationController.viewControllers = secondaryTokens
            .compactMap { registry.createViewController(from: $0, context: self) }

        splitController.preferredDisplayMode = .oneBesideSecondary
        splitController.presentsWithGesture = false
        splitController.viewControllers = [primaryViewController, navigationController]
    }

    // MARK: - SplitMultiContext

    func showDetail(tokens: [T]) -> Bool {
        let navigationController = UINavigationController()
        navigationController.viewControllers = tokens
            .compactMap { registry.createViewController(from: $0, context: self) }
        splitController.showDetailViewController(navigationController, sender: nil)
        return true
    }
}
