//
//  Created by Ceri Hughes on 19/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation
import Provident

class Registrar<T> {
    private let bridged = Provident.Registrar<T, AnyContainer<T>>()

    var serviceProviders: [String: ServiceProvider] { bridged.serviceProviders }
    var viewControllerProviders: [AnyViewControllerProvider<T>] { bridged.viewControllerProviders.map { $0.bridged() } }
    var registry: AnyRegistry<T> { bridged.registry.bridged() }

    func resolve(
        serviceProviderFunctions: [ServiceProviderFunction],
        viewControllerProviderFunctions: [ViewControllerProviderFunction<T>],
        launchOptions: LaunchOptions? = nil
    ) {
        let functions = viewControllerProviderFunctions.map { ResolverBridge.bridge(madog: $0) }
        bridged.resolve(
            serviceProviderFunctions: serviceProviderFunctions,
            viewControllerProviderFunctions: functions,
            launchOptions: launchOptions
        )
    }

    func resolve(resolver: AnyResolver<T>, launchOptions: LaunchOptions? = nil) {
        bridged.resolve(resolver: resolver.bridged(), launchOptions: launchOptions)
    }
}
