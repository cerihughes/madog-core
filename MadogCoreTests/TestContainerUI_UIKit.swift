//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import MadogCore
import UIKit

class TestContainerUI<T>: ContainerUI<T, SingleUITokenData<T>, ViewController> {
    private let containerController = ViewController()

    init?(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) {
        super.init(registry: registry, containerViewController: containerController)

        guard let vc = registry.createViewController(from: tokenData.token, container: self) else { return nil }

        vc.willMove(toParent: containerController)

        containerController.addChild(vc)
        containerController.view.addSubview(vc.view)
        vc.view.frame = containerController.view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        vc.didMove(toParent: containerController)
    }
}

#endif
