//
//  Created by Ceri Hughes on 11/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import MadogCore
import UIKit

class KIFTestContainerUI<T>: ContainerUI<T, SingleUITokenData<T>, ViewController> {
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

extension KIFTestContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, SingleUITokenData<T>, ViewController> {
            KIFTestContainerUI(viewController: .init())
        }
    }
}

public extension ContainerUI.Identifier where VC == ViewController, TD == SingleUITokenData<T> {
    static func kifTest() -> Self { .init("kifTestIdentifier") }
}

public extension Madog {
    func registerTestContainers() {
        _ = addContainerUIFactory(identifier: .kifTest(), factory: KIFTestContainerUI.Factory())
    }
}

#endif
