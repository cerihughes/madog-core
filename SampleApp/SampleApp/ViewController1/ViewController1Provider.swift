//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

private let vc1Identifier = "vc1Identifier"

class ViewController1Provider: ViewControllerProvider {
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
            token.identifier == vc1Identifier,
            let context = context as? AnyForwardBackNavigationContext<SampleToken>
        else { return nil }

        let viewController = ViewController1(sharedService: sharedService, context: context)
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        return viewController
    }
}

extension SampleToken {
    static var vc1: SampleToken {
        SampleToken(identifier: vc1Identifier, data: [:])
    }
}
