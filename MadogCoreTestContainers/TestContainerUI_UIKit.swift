//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if DEBUG && canImport(UIKit)

import MadogCore
import UIKit

class TestContainerUI<T>: ContainerUI<T, SingleUITokenData<T>, ViewController> {
    override func populateContainer(tokenData: SingleUITokenData<T>) throws {
        try super.populateContainer(tokenData: tokenData)

        let vc = try createContentViewController(from: tokenData.token)

        vc.willMove(toParent: containerViewController)

        containerViewController.addChild(vc)
        containerViewController.view.addSubview(vc.view)
        vc.view.frame = containerViewController.view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        vc.didMove(toParent: containerViewController)
    }
}

#endif
