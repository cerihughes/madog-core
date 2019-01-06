//
//  Page1.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

fileprivate let page1Identifier = "page1Identifier"

class Page1: PageObject {
    private var state1: State1?
    private var uuid: UUID?

    // MARK: PageObject

    override func register(with registry: ViewControllerRegistry) {
        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    override func unregister(from registry: ViewControllerRegistry) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    override func configure(with state: [String : State]) {
        state1 = state[state1Name] as? State1
    }

    // MARK: Private

    private func createViewController(token: Any, context: Context) -> UIViewController? {
        guard let state1 = state1,
            let rl = token as? ResourceLocator,
            rl.identifier == page1Identifier,
            let navigationContext = context as? ForwardBackNavigationContext else {
                return nil
        }

        let viewController =  Page1ViewController(state1: state1, navigationContext: navigationContext)
        viewController.tabBarItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 0)
        return viewController
    }
}

extension ResourceLocator {
    static var page1ResourceLocator: ResourceLocator {
        return ResourceLocator(identifier: page1Identifier, data: [:])
    }
}
