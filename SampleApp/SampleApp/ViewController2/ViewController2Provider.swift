//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

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
            case let .vc2(stringData) = token,
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
