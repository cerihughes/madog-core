//
//  LoginViewControllerProvider.swift
//  MadogSample
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

private let loginIdentifier = "loginIdentifier"

class LoginViewControllerProvider: SingleViewControllerProvider<SampleToken> {
    private var authenticator: Authenticator?

    // MARK: - SingleViewControllerProvider

    override func configure(with serviceProviders: [String: ServiceProvider]) {
        if let authenticatorProvider = serviceProviders[authenticatorProviderName] as? AuthenticatorProvider {
            authenticator = authenticatorProvider.authenticator
        }
    }

    override func createViewController(token: SampleToken, context: Context) -> UIViewController? {
        guard token.identifier == loginIdentifier,
            let authenticator = authenticator,
            let navigationContext = context as? Context & ForwardBackNavigationContext else {
            return nil
        }

        return LoginViewController.createLoginViewController(authenticator: authenticator, navigationContext: navigationContext)
    }
}

extension SampleToken {
    static var login: SampleToken {
        SampleToken(identifier: loginIdentifier, data: [:])
    }
}
