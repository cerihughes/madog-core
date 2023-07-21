//
//  ViewController2Provider.swift
//  MadogSample
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

private let vc2Identifier = "vc2Identifier"

class ViewController2Provider: ViewControllerProvider {
    private var sharedService: Any?

    // MARK: - ViewControllerProvider

    func configure(with serviceProviders: [String: ServiceProvider]) {
        if let serviceProvider = serviceProviders[serviceProvider1Name] as? ServiceProvider1 {
            sharedService = serviceProvider.somethingShared
        }
    }

    func createViewController(token: SampleToken, context: AnyContext<SampleToken>) -> UIViewController? {
        guard
            let sharedService,
            token.identifier == vc2Identifier,
            let stringData = token.stringData,
            let context = context as? AnyForwardBackNavigationContext<SampleToken>
        else { return nil }

        let viewController = ViewController2(
            sharedService: sharedService,
            stringData: stringData,
            context: context
        )
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        return viewController
    }
}

extension SampleToken {
    private static let stringDataKey = "stringData"

    static func createVC2Identifier(stringData: String) -> SampleToken {
        SampleToken(identifier: vc2Identifier, data: [stringDataKey: stringData])
    }

    var stringData: String? {
        data[SampleToken.stringDataKey] as? String
    }
}
