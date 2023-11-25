//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import Foundation

open class NavigatingContainerUI<T>: ContainerUI<T, SingleUITokenData<T>, NavigationController>, ForwardBackContainer {
    // MARK: - ForwardBackContainer

    public func navigateForward(token: Token<T>, animated: Bool) -> Bool {
        guard let toViewController = try? createContentViewController(from: token) else { return false }
        containerViewController.pushViewController(toViewController, animated: animated)
        return true
    }

    public func navigateBack(animated: Bool) -> Bool {
        containerViewController.popViewController(animated: animated) != nil
    }

    public func navigateBackToRoot(animated _: Bool) -> Bool {
        containerViewController.popToRootViewController(animated: true) != nil
    }
}

#endif
