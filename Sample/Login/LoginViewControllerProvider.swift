//
//  LoginViewControllerProvider.swift
//  MadogSample
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

fileprivate let loginIdentifier = "loginIdentifier"

class LoginViewControllerProvider: ViewControllerProvider<SampleToken, Context> {
    private var authenticator: Authenticator?
    private var uuid: UUID?

    // MARK: ViewControllerProviderObject

    override func register(with registry: ViewControllerRegistry<SampleToken, Context>) {
        uuid = registry.add(registryFunctionWithContext: createViewController(token:context:))
    }

    override func unregister(from registry: ViewControllerRegistry<SampleToken, Context>) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    override func configure(with serviceProviders: [String : ServiceProvider]) {
        if let authenticatorProvider = serviceProviders[authenticatorProviderName] as? AuthenticatorProvider {
            authenticator = authenticatorProvider.authenticator
        }
    }

    // MARK: Private

    private func createViewController(token: Any, context: Context) -> UIViewController? {
        guard let sampleToken = token as? SampleToken,
            sampleToken.identifier == loginIdentifier,
            let authenticator = authenticator,
            let navigationContext = context as? Context & ForwardBackNavigationContext else {
                return nil
        }

        return LoginViewController.createLoginViewController(authenticator: authenticator, navigationContext: navigationContext)
    }
}

extension SampleToken {
    static var login: SampleToken {
        return SampleToken(identifier: loginIdentifier, data: [:])
    }
}
