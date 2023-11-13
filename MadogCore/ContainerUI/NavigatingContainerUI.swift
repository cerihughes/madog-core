//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import Foundation

open class NavigatingContainerUI<T>: ContainerUI<T, NavigationController>, ForwardBackContainer {
    open func provideNavigationController() -> NavigationController? {
        // OVERRIDE
        nil
    }

    // MARK: - ForwardBackContainer

    public func navigateForward(token: Token<T>, animated: Bool) -> Bool {
        guard
            let toViewController = createViewController(from: token),
            let navigationController = provideNavigationController()
        else { return false }

        navigationController.pushViewController(toViewController, animated: animated)
        return true
    }

    public func navigateBack(animated: Bool) -> Bool {
        guard let navigationController = provideNavigationController() else { return false }
        return navigationController.popViewController(animated: animated) != nil
    }

    public func navigateBackToRoot(animated _: Bool) -> Bool {
        guard let navigationController = provideNavigationController() else { return false }
        return navigationController.popToRootViewController(animated: true) != nil
    }
}

#endif
