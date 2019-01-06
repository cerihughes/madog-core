//
//  LoginViewControllerProvider.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

fileprivate let loginIdentifier = "loginIdentifier"

class LoginViewControllerProvider: ViewControllerProviderObject {
    private var authenticator: Authenticator?
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
        if let authenticatorProvider = resourceProviders[authenticatorProviderName] as? AuthenticatorProvider {
            authenticator = authenticatorProvider.authenticator
        }
    }

    // MARK: Private

    private func createViewController(token: Any, context: Context) -> UIViewController? {
        guard let rl = token as? ResourceLocator,
            rl.identifier == loginIdentifier,
            let authenticator = authenticator,
            let navigationContext = context as? Context & ForwardBackNavigationContext else {
                return nil
        }

        return LoginViewController.createLoginViewController(authenticator: authenticator, navigationContext: navigationContext)
    }
}

extension ResourceLocator {
    static var loginResourceLocator: ResourceLocator {
        return ResourceLocator(identifier: loginIdentifier, data: [:])
    }
}
