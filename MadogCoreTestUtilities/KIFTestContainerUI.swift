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

        let viewController = try createContentViewController(contentFactory: contentFactory, from: tokenData.token)
        viewController.willMove(toParent: containerViewController)

        containerViewController.addChild(viewController)
        containerViewController.view.addSubview(viewController.view)
        viewController.view.frame = containerViewController.view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewController.didMove(toParent: containerViewController)
    }
}

extension KIFTestContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, SingleUITokenData<T>, ViewController> {
            KIFTestContainerUI(containerViewController: .init())
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
