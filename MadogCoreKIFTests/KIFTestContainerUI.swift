//
//  Created by Ceri Hughes on 11/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import MadogCore
import UIKit

class KIFTestContainerUI<T>: ContainerUI<T> {
    private let containerController = ViewController()

    init?(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) {
        super.init(registry: registry, viewController: containerController)

        guard let vc = registry.createViewController(from: tokenData.token, container: self) else { return nil }

        vc.willMove(toParent: containerController)

        containerController.addChild(vc)
        containerController.view.addSubview(vc.view)
        vc.view.frame = containerController.view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        vc.didMove(toParent: containerController)
    }
}

extension KIFTestContainerUI {
    struct Factory: SingleContainerUIFactory {
        func createContainer(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> ContainerUI<T>? {
            KIFTestContainerUI(registry: registry, tokenData: tokenData)
        }
    }
}

public extension ContainerUI.Identifier where VC == ViewController, TD == SingleUITokenData<T> {
    static func kifTest() -> Self { .init("kifTestIdentifier") }
}

#endif
