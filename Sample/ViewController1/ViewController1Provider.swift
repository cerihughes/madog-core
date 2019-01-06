//
//  ViewController1Provider.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

fileprivate let vc1Identifier = "vc1Identifier"

class ViewController1Provider: ViewControllerProviderObject {
    private var sharedResource: Any?
    private var uuid: UUID?

    // MARK: ViewControllerProviderObject

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
            let sampleToken = token as? SampleToken,
            sampleToken.identifier == vc1Identifier,
            let navigationContext = context as? ForwardBackNavigationContext else {
                return nil
        }

        let viewController =  ViewController1(sharedResource: sharedResource, navigationContext: navigationContext)
        viewController.tabBarItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 0)
        return viewController
    }
}

extension SampleToken {
    static var vc1: SampleToken {
        return SampleToken(identifier: vc1Identifier, data: [:])
    }
}
