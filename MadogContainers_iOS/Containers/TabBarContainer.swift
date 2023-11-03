//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class TabBarContainer<T>: MadogModalUIContainer<T>, TabBarUIContext {
    private let tabBarController = UITabBarController()

    init(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) {
        super.init(registry: registry, viewController: tabBarController)

        let viewControllers = tokenData.tokens.compactMap { registry.createViewController(from: $0, context: self) }

        tabBarController.viewControllers = viewControllers
    }

    // MARK: - MultiContext

    var selectedIndex: Int {
        get { tabBarController.selectedIndex }
        set { tabBarController.selectedIndex = newValue }
    }
}

struct TabBarContainerFactory<T>: MultiContainerFactory {
    func createContainer(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) -> MadogUIContainer<T>? {
        TabBarContainer(registry: registry, tokenData: tokenData)
    }
}
