//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import MadogCore
import UIKit

class TestNavigatingContainerUI<T>: NavigatingContainerUI<T> {
    private let navigationController = UINavigationController()

    init?(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) {
        super.init(registry: registry, viewController: navigationController)

        guard let viewController = registry.createViewController(from: tokenData.token, container: self) else {
            return nil
        }
        navigationController.setViewControllers([viewController], animated: false)
    }

    override func provideNavigationController() -> UINavigationController? {
        navigationController
    }
}

extension TestNavigatingContainerUI {
    struct Factory: SingleContainerUIFactory {
        func createContainer(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> ContainerUI<T>? {
            TestNavigatingContainerUI(registry: registry, tokenData: tokenData)
        }
    }
}

extension ContainerUI.Identifier where VC == UINavigationController, TD == SingleUITokenData<T> {
    static func testNavigation() -> Self { .init("testNavigatingIdentifier") }
}

#endif
