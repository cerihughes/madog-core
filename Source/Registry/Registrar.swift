//
//  Registrar.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public class Registrar<T, C> {
    public let registry: ViewControllerRegistry<T, C>

    public private(set) var serviceProviders = [String : ServiceProvider]()
    internal private(set) var viewControllerProviders = [ViewControllerProvider<T, C>]()

    public init(registry: ViewControllerRegistry<T, C>) {
        self.registry = registry
    }

    deinit {
        unregisterViewControllerProviders()
    }

    public func resolve(resolver: Resolver<T, C>, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let context = ServiceProviderCreationContextImplementation()
        context.launchOptions = launchOptions
        createServiceProviders(functions: resolver.serviceProviderCreationFunctions(), context: context)
        registerViewControllerProviders(functions: resolver.viewControllerProviderCreationFunctions())
    }

    internal func createServiceProviders(functions: [(ServiceProviderCreationContext) -> ServiceProvider],
                                         context: ServiceProviderCreationContext) {
        for function in functions {
            let serviceProvider = function(context)
            let name = serviceProvider.name
            serviceProviders[name] = serviceProvider
        }
    }

    internal func registerViewControllerProviders(functions: [() -> ViewControllerProvider<T, C>]) {
        for function in functions {
            let viewControllerProvider = function()
            viewControllerProvider.register(with: registry)
            viewControllerProvider.configure(with: serviceProviders)
            viewControllerProviders.append(viewControllerProvider)
        }
    }

    internal func unregisterViewControllerProviders() {
        for viewControllerProvider in viewControllerProviders {
            viewControllerProvider.unregister(from: registry)
        }
        viewControllerProviders.removeAll()
    }
}
