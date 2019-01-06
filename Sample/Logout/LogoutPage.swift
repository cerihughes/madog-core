//
//  LogoutPage.swift
//  MadogSample
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

fileprivate let logoutPageIdentifier = "logoutPageIdentifier"

class LogoutPage: PageObject {
    private var authenticatorState: AuthenticatorState?
    private var uuid: UUID?

    // MARK: PageObject

    override func register(with registry: ViewControllerRegistry) {
        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    override func unregister(from registry: ViewControllerRegistry) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    override func configure(with state: [String : State]) {
        authenticatorState = state[authenticatorStateName] as? AuthenticatorState
    }

    // MARK: Private

    private func createViewController(token: Any, context: Context) -> UIViewController? {
        guard let authenticator = authenticatorState?.authenticator,
            let rl = token as? ResourceLocator,
            rl.identifier == logoutPageIdentifier else {
                return nil
        }

        let viewController =  LogoutViewController(authenticator: authenticator, context: context)
        viewController.tabBarItem = UITabBarItem.init(tabBarSystemItem: .history, tag: 0)
        return viewController
    }
}

extension ResourceLocator {
    static var logoutPageResourceLocator: ResourceLocator {
        return ResourceLocator(identifier: logoutPageIdentifier, data: [:])
    }
}
