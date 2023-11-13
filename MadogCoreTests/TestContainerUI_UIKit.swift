//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import MadogCore
import UIKit

class TestContainerUI<T>: ContainerUI<T, SingleUITokenData<T>, ViewController> {
    override func populateContainer(
        contentFactory: AnyContainerUIContentFactory<T>,
        tokenData: SingleUITokenData<T>
    ) throws {
        try super.populateContainer(contentFactory: contentFactory, tokenData: tokenData)

        let viewController = try createContentViewController(contentFactory: contentFactory, from: tokenData.token)

        viewController.willMove(toParent: containerViewController)

        containerViewController.addChild(viewController)
        containerViewController.view.addSubview(viewController.view)
        viewController.view.frame = containerViewController.view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewController.didMove(toParent: containerViewController)
    }
}

#endif
