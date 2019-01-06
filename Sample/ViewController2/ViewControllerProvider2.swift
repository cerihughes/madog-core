//
//  ViewControllerProvider2.swift
//  MadogSample
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

fileprivate let vc2Identifier = "vc2Identifier"

class ViewControllerProvider2: ViewControllerProviderObject {
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
            sampleToken.identifier == vc2Identifier,
            let stringData = sampleToken.stringData,
            let navigationContext = context as? ForwardBackNavigationContext else {
                return nil
        }

        let viewController = ViewController2(sharedResource: sharedResource,
                                                 stringData: stringData,
                                                 navigationContext: navigationContext)
        viewController.tabBarItem = UITabBarItem.init(tabBarSystemItem: .contacts, tag: 0)
        return viewController
    }
}

extension SampleToken {
    private static let stringDataKey = "stringData"

    static func createVC2Identifier(stringData: String) -> SampleToken {
        return SampleToken(identifier: vc2Identifier, data: [stringDataKey : stringData])
    }

    var stringData: String? {
        return data[SampleToken.stringDataKey] as? String
    }
}
