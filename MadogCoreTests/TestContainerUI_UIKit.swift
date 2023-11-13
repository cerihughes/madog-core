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

        let vc = try createContentViewController(contentFactory: contentFactory, from: tokenData.token)

        vc.willMove(toParent: viewController)

        viewController.addChild(vc)
        viewController.view.addSubview(vc.view)
        vc.view.frame = viewController.view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        vc.didMove(toParent: viewController)
    }
}

#endif
