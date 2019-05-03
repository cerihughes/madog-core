//
//  LogoutViewControllerProvider.swift
//  MadogSample
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

fileprivate let logoutIdentifier = "logoutIdentifier"

class LogoutViewControllerProvider: ViewControllerProvider<SampleToken> {
    private var authenticator: Authenticator?
    private var uuid: UUID?

    // MARK: ViewControllerProviderObject

    override func register(with registry: ViewControllerRegistry<SampleToken>) {
        uuid = registry.add(registryFunctionWithContext: createViewController(token:context:))
    }

    override func unregister(from registry: ViewControllerRegistry<SampleToken>) {
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
        guard let authenticator = authenticator,
            let sampleToken = token as? SampleToken,
            sampleToken.identifier == logoutIdentifier else {
                return nil
        }

        let viewController =  LogoutViewController(authenticator: authenticator, context: context)
        viewController.tabBarItem = UITabBarItem.init(tabBarSystemItem: .history, tag: 0)
        return viewController
    }
}

extension SampleToken {
    static var logout: SampleToken {
        return SampleToken(identifier: logoutIdentifier, data: [:])
    }
}
