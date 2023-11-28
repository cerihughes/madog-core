//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import Foundation

open class NavigatingContainerUI<T>: ContainerUI<T, SingleUITokenData<T>, NavigationController>, ForwardBackContainer {
    private var contentFactory: AnyContainerUIContentFactory<T>?

    override open func populateContainer(
        contentFactory: AnyContainerUIContentFactory<T>,
        tokenData: SingleUITokenData<T>
    ) throws {
        self.contentFactory = contentFactory
    }

    // MARK: - ForwardBackContainer

    public func navigateForward(token: T, animated: Bool) throws {
        guard let contentFactory else { throw MadogError<T>.internalError("ContentFactory not set in \(self)") }
        let toViewController = try createContentViewController(contentFactory: contentFactory, from: token)
        containerViewController.pushViewController(toViewController, animated: animated)
    }

    public func navigateBack(animated: Bool) throws {
        let popped = containerViewController.popViewController(animated: animated)
        if popped == nil {
            throw MadogError<T>.cannotNavigateBack
        }
    }

    public func navigateBackToRoot(animated _: Bool) throws {
        let popped = containerViewController.popToRootViewController(animated: true)
        if popped == nil {
            throw MadogError<T>.cannotNavigateBack
        }
    }
}

#endif
