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

class Page2: PageObject {
    private var sharedResource: Any?
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

    override func configure(with resourceProviders: [String : ResourceProvider]) {
        if let resourceProvider = resourceProviders[resourceProvider1Name] as? ResourceProvider1 {
            sharedResource = resourceProvider.somethingShared
        }
    }

    // MARK: Private

    private func createViewController(token: Any, context: Context) -> UIViewController? {
        guard let sharedResource = sharedResource,
            let rl = token as? ResourceLocator,
            rl.identifier == page2Identifier,
            let pageData = rl.pageData,
            let navigationContext = context as? ForwardBackNavigationContext else {
                return nil
        }

        let viewController = Page2ViewController(sharedResource: sharedResource,
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
