//
//  Created by Ceri Hughes on 11/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

protocol SplitContext<T>: Context {
    @discardableResult
    func showDetail(token: T) -> Bool
}
typealias AnySplitContext<T> = any SplitContext<T>

extension MadogUIIdentifier
where VC == UISplitViewController, C == AnySplitContext<T>, TD == SplitSingleUITokenData<T> {
    static func split() -> Self { MadogUIIdentifier("splitViewControllerIdentifier") }
}

class SplitUI<T>: MadogUIContainer<T>, SplitContext {
    private let splitController = UISplitViewController()

    init?(registry: AnyRegistry<T>, tokenData: SplitSingleUITokenData<T>) {
        super.init(registry: registry, viewController: splitController)

        guard let primary = registry.createViewController(from: tokenData.primaryToken, context: self) else {
            return nil
        }

        let secondary = tokenData.secondaryToken.flatMap { registry.createViewController(from: $0, context: self) }

        splitController.preferredDisplayMode = .oneBesideSecondary
        splitController.presentsWithGesture = false
        splitController.viewControllers = [primary, secondary]
            .compactMap { $0 }
    }

    // MARK: - SplitContext

    func showDetail(token: T) -> Bool {
        guard let viewController = registry.createViewController(from: token, context: self) else { return false }
        splitController.showDetailViewController(viewController, sender: nil)
        return true
    }
}

struct SplitUIFactory<T>: SplitSingleContainerFactory {
    func createContainer(registry: AnyRegistry<T>, tokenData: SplitSingleUITokenData<T>) -> MadogUIContainer<T>? {
        SplitUI(registry: registry, tokenData: tokenData)
    }
}
