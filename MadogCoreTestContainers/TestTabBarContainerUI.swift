//
//  Created by Ceri Hughes on 24/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class TestTabBarContainerUI<T>: ContainerUI<T, MultiUITokenData<T>, UITabBarController>, MultiContainer {
    private let tabBarController = UITabBarController()

    override func populateContainer(
        contentFactory: AnyContainerUIContentFactory<T>,
        tokenData: MultiUITokenData<T>
    ) throws {
        try super.populateContainer(contentFactory: contentFactory, tokenData: tokenData)

        let viewControllers = try tokenData.tokens.compactMap {
            try createContentViewController(contentFactory: contentFactory, from: $0)
        }

        tabBarController.viewControllers = viewControllers
    }

    // MARK: - MultiContainer

    var selectedIndex: Int {
        get { tabBarController.selectedIndex }
        set { tabBarController.selectedIndex = newValue }
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
