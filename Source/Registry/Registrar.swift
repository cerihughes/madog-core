//
//  Registrar.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public class Registrar {
    public let registry: ViewControllerRegistry

    public private(set) var resourceProviders = [String : ResourceProvider]()
    internal private(set) var viewControllerProviders = [ViewControllerProvider]()

    public init(registry: ViewControllerRegistry) {
        self.registry = registry
    }

    deinit {
        unregisterViewControllerProviders(from: registry)
    }

    public func resolve(resolver: Resolver, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        let context = ResourceProviderCreationContextImplementation()
        context.launchOptions = launchOptions
        createResourceProviders(functions: resolver.resourceProviderCreationFunctions(), context: context)
        registerViewControllerProviders(with: registry, functions: resolver.viewControllerProviderCreationFunctions())
    }

    internal func createResourceProviders(functions: [ResourceProviderCreationFunction], context: ResourceProviderCreationContext) {
        for function in functions {
            let resourceProvider = function(context)
            let name = resourceProvider.name
            resourceProviders[name] = resourceProvider
        }
    }

    internal func registerViewControllerProviders(with registry: ViewControllerRegistry, functions: [ViewControllerProviderCreationFunction]) {
        for function in functions {
            let viewControllerProvider = function()
            viewControllerProvider.register(with: registry)
            viewControllerProvider.configure(with: resourceProviders)
            viewControllerProviders.append(viewControllerProvider)
        }
    }

    internal func unregisterViewControllerProviders(from registry: ViewControllerRegistry) {
        for viewControllerProvider in viewControllerProviders {
            viewControllerProvider.unregister(from: registry)
        }
        viewControllerProviders.removeAll()
    }
}
