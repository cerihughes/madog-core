//
//  ViewControllerProvider2.swift
//  MadogSample
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

fileprivate let vc2Identifier = "vc2Identifier"

class ViewControllerProvider2: ViewControllerProvider {
    private var sharedService: Any?
    private var uuid: UUID?

    // MARK: ViewControllerProviderObject

    override func register(with registry: ViewControllerRegistry) {
        uuid = registry.add(registryFunctionWithContext: createViewController(token:context:))
    }

    override func unregister(from registry: ViewControllerRegistry) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    override func configure(with serviceProviders: [String : ServiceProvider]) {
        if let serviceProvider = serviceProviders[serviceProvider1Name] as? ServiceProvider1 {
            sharedService = serviceProvider.somethingShared
        }
    }

    // MARK: Private

    private func createViewController(token: Any, context: Context) -> UIViewController? {
        guard let sharedService = sharedService,
            let sampleToken = token as? SampleToken,
            sampleToken.identifier == vc2Identifier,
            let stringData = sampleToken.stringData,
            let navigationContext = context as? ForwardBackNavigationContext else {
                return nil
        }

        let viewController = ViewController2(sharedService: sharedService,
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
