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

    public func navigateForward(token: Token<T>, animated: Bool) -> Bool {
        guard
            let contentFactory,
            let vc = try? createContentViewController(contentFactory: contentFactory, from: token)
        else { return false }

        viewController.pushViewController(vc, animated: animated)
        return true
    }

    public func navigateBack(animated: Bool) -> Bool {
        viewController.popViewController(animated: animated) != nil
    }

    public func navigateBackToRoot(animated _: Bool) -> Bool {
        viewController.popToRootViewController(animated: true) != nil
    }
}

#endif
