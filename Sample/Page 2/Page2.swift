//
//  Page2.swift
//  MadogSample
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

fileprivate let page2Identifier = "page2Identifier"

class Page2: PageFactory, StatefulPage {
    private var state1: State1?
    private var uuid: UUID?

    // MARK: PageFactory

    static func createPage() -> Page {
        return Page2()
    }

    // MARK: StatefulPage1

    func configure(with state: [String : State]) {
        state1 = state[state1Name] as? State1
    }

    // MARK: Page

    func register(with registry: ViewControllerRegistry) {
        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    func unregister(from registry: ViewControllerRegistry) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    // MARK: Private

    private func createViewController(token: Any, context: Context) -> UIViewController? {
        guard let state1 = state1,
            let rl = token as? ResourceLocator,
            rl.identifier == page2Identifier,
            let pageData = rl.pageData,
            let navigationContext = context as? ForwardBackNavigationContext else {
            return nil
        }

        let viewController = Page2ViewController(state1: state1,
                                                 pageData: pageData,
                                                 navigationContext: navigationContext)
        viewController.tabBarItem = UITabBarItem.init(tabBarSystemItem: .contacts, tag: 0)
        return viewController
    }
}

extension ResourceLocator {
    private static let pageDataKey = "pageData"

    static func createPage2ResourceLocator(pageData: String) -> ResourceLocator {
        return ResourceLocator(identifier: page2Identifier, data: [pageDataKey : pageData])
    }

    var pageData: String? {
        return data[ResourceLocator.pageDataKey] as? String
    }
}
