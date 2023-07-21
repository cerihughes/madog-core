//
//  Registrar.swift
//  Madog
//
//  Created by Ceri Hughes on 19/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

class Registrar<T> {
    let registry: RegistryImplementation<T>

    private(set) var serviceProviders = [String: ServiceProvider]()
    private(set) var viewControllerProviders = [AnyViewControllerProvider<T>]()

    init(registry: RegistryImplementation<T>) {
        self.registry = registry
    }

    deinit {
        registry.reset()
    }

    func resolve(
        serviceProviderFunctions: [ServiceProviderFunction],
        viewControllerProviderFunctions: [ViewControllerProviderFunction<T>],
        launchOptions: LaunchOptions? = nil
    ) {
        let context = ServiceProviderCreationContextImplementation()
        context.launchOptions = launchOptions
        createServiceProviders(functions: serviceProviderFunctions, context: context)
        registerViewControllerProviders(functions: viewControllerProviderFunctions)
    }

    func resolve(resolver: AnyResolver<T>, launchOptions: LaunchOptions? = nil) {
        resolve(
            serviceProviderFunctions: resolver.serviceProviderFunctions(),
            viewControllerProviderFunctions: resolver.viewControllerProviderFunctions()
        )
    }

    func createServiceProviders(functions: [ServiceProviderFunction], context: ServiceProviderCreationContext) {
        for function in functions {
            let serviceProvider = function(context)
            let name = serviceProvider.name
            serviceProviders[name] = serviceProvider
        }
    }

    func registerViewControllerProviders(functions: [ViewControllerProviderFunction<T>]) {
        for function in functions {
            let viewControllerProvider = function()
            registry.add(registryFunction: viewControllerProvider.createViewController(token:context:))
            viewControllerProvider.configure(with: serviceProviders)
            viewControllerProviders.append(viewControllerProvider)
        }
    }
}
