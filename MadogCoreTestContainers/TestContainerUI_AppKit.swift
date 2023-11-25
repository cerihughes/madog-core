//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if DEBUG && canImport(AppKit)

import MadogCore
import AppKit

class TestContainerUI<T>: ContainerUI<T, SingleUITokenData<T>, ViewController> {
    override func populateContainer(tokenData: SingleUITokenData<T>) {
        super.populateContainer(tokenData: tokenData)

        guard let vc = createContentViewController(from: tokenData.token) else { return }

        containerViewController.addChild(vc)
        containerViewController.view.addSubview(vc.view)
        vc.view.frame = containerViewController.view.bounds
        vc.view.autoresizingMask = [.width, .height]
    }
}

#endif
