//
//  Registrar.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

internal class Registrar {
    internal var resourceProviders = [String : ResourceProvider]()
    internal var viewControllerProviders = [ViewControllerProvider]()

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
