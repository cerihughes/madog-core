//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(AppKit)

import MadogCore
import AppKit

class TestContainer<T>: Container<T> {
    private let containerController = ViewController()

    init?(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) {
        super.init(registry: registry, viewController: containerController)

        guard let vc = registry.createViewController(from: tokenData.token, container: self) else { return nil }

        containerController.addChild(vc)
        containerController.view.addSubview(vc.view)
        vc.view.frame = containerController.view.bounds
        vc.view.autoresizingMask = [.width, .height]
    }
}

#endif
