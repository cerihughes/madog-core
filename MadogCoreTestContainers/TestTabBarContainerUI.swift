//
//  Created by Ceri Hughes on 24/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if DEBUG && canImport(UIKit)

import MadogCore
import UIKit

class TestTabBarContainerUI<T>: ContainerUI<T, MultiUITokenData<T>, UITabBarController>, MultiContainer {
    override func populateContainer(tokenData: MultiUITokenData<T>) throws {
        try super.populateContainer(tokenData: tokenData)

        let viewControllers = try tokenData.tokens.compactMap {
            try createContentViewController(token: $0)
        }

        containerViewController.viewControllers = viewControllers
    }

    // MARK: - MultiContainer

    var selectedIndex: Int {
        get { containerViewController.selectedIndex }
        set { containerViewController.selectedIndex = newValue }
    }
}

extension TestTabBarContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, MultiUITokenData<T>, UITabBarController> {
            TestTabBarContainerUI(containerViewController: .init())
        }
    }
}

public extension ContainerUI.Identifier where VC == UITabBarController, TD == MultiUITokenData<T> {
    static func testTabBar() -> Self { .init("testTabBarIdentifier") }
}

#endif
