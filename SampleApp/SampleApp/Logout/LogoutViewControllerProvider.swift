//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class LogoutViewControllerProvider: ViewControllerProvider {
    private var authenticator: Authenticator?

    // MARK: - ViewControllerProvider

    func configure(with serviceProviders: [String: ServiceProvider]) {
        if let authenticatorProvider = serviceProviders[authenticatorProviderName] as? AuthenticatorProvider {
            authenticator = authenticatorProvider.authenticator
        }
    }

    func createViewController(token: SampleToken, context: AnyContext<SampleToken>) -> UIViewController? {
        guard let authenticator, token == .logout else { return nil }
        let viewController = LogoutViewController(authenticator: authenticator, context: context)
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        return viewController
    }
}
