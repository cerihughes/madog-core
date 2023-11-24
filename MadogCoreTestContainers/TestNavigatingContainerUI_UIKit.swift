//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if canImport(UIKit)

import MadogCore
import UIKit

class TestNavigatingContainerUI<T>: NavigatingContainerUI<T> {
    override func populateContainer(
        contentFactory: AnyContainerUIContentFactory<T>,
        tokenData: SingleUITokenData<T>
    ) throws {
        try super.populateContainer(contentFactory: contentFactory, tokenData: tokenData)

        let viewController = try createContentViewController(contentFactory: contentFactory, from: tokenData.token)
        containerViewController.setViewControllers([viewController], animated: false)
    }
}

extension TestNavigatingContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, SingleUITokenData<T>, NavigationController> {
            TestNavigatingContainerUI(containerViewController: .init())
        }
    }
}

public extension ContainerUI.Identifier where VC == UINavigationController, TD == SingleUITokenData<T> {
    static func testNavigation() -> Self { .init("testNavigatingIdentifier") }
}

#endif
