//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import Foundation

open class NavigatingContainerUI<T>: ContainerUI<T, SingleUITokenData<T>, NavigationController>, ForwardBackContainer {
    // MARK: - ForwardBackContainer

    public func navigateForward(token: Token<T>, animated: Bool) throws {
        let toViewController = try createContentViewController(token: token)
        containerViewController.pushViewController(toViewController, animated: animated)
    }

    public func navigateBack(animated: Bool) throws {
        let popped = containerViewController.popViewController(animated: animated)
        if popped == nil {
            throw MadogError.cannotNavigateBack
        }
    }

    public func navigateBackToRoot(animated _: Bool) throws {
        let popped = containerViewController.popToRootViewController(animated: true)
        if popped == nil {
            throw MadogError.cannotNavigateBack
        }
    }
}

#endif
