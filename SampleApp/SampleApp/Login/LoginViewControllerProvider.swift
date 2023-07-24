//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

private let loginIdentifier = "loginIdentifier"

class LoginViewControllerProvider: ViewControllerProvider {
    private var authenticator: Authenticator?

    // MARK: - ViewControllerProvider

    func configure(with serviceProviders: [String: ServiceProvider]) {
        if let authenticatorProvider = serviceProviders[authenticatorProviderName] as? AuthenticatorProvider {
            authenticator = authenticatorProvider.authenticator
        }
    }

    func createViewController(token: SampleToken, context: AnyContext<SampleToken>) -> UIViewController? {
        guard token.identifier == loginIdentifier, let authenticator else { return nil }
        return LoginViewController.createLoginViewController(authenticator: authenticator, context: context)
    }
}

extension SampleToken {
    static var login: SampleToken {
        SampleToken(identifier: loginIdentifier, data: [:])
    }
}
