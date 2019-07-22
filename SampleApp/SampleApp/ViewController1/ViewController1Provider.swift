//
//  ViewController1Provider.swift
//  MadogSample
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

fileprivate let vc1Identifier = "vc1Identifier"

class ViewController1Provider: ViewControllerProvider<SampleToken> {
    private var sharedService: Any?
    private var uuid: UUID?

    // MARK: ViewControllerProviderObject

    override func register(with registry: Registry<SampleToken>) {
        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    override func unregister(from registry: Registry<SampleToken>) {
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
            sampleToken.identifier == vc1Identifier,
            let navigationContext = context as? ForwardBackNavigationContext else {
                return nil
        }

        let viewController =  ViewController1(sharedService: sharedService, navigationContext: navigationContext)
        viewController.tabBarItem = UITabBarItem.init(tabBarSystemItem: .bookmarks, tag: 0)
        return viewController
    }
}

extension SampleToken {
    static var vc1: SampleToken {
        return SampleToken(identifier: vc1Identifier, data: [:])
    }
}
