//
//  MadogTypes.swift
//  Madog
//
//  Created by Ceri Hughes on 03/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Provident

public class Registry<Token>: Provident.Registry<Token, Context> {}

open class ViewControllerProvider<Token>: Provident.ViewControllerProvider<Token, Context> {
    override public final func register(with registry: Provident.Registry<Token, Context>) {
        guard let registry = registry as? Registry else {
            return
        }

        register(with: registry)
    }

    override public final func unregister(from registry: Provident.Registry<Token, Context>) {
        guard let registry = registry as? Registry else {
            return
        }

        unregister(from: registry)
    }

    open func register(with registry: Registry<Token>) {}
    open func unregister(from registry: Registry<Token>) {}
}

open class Resolver<Token>: Provident.Resolver<Token, Context> {
    override public final func viewControllerProviderCreationFunctions() -> [() -> Provident.ViewControllerProvider<Token, Context>] {
        let functions: [() -> ViewControllerProvider<Token>] = viewControllerProviderCreationFunctions()
        return functions.map(convert)
    }

    private func convert(input: @escaping () -> ViewControllerProvider<Token>) -> (() -> Provident.ViewControllerProvider<Token, Context>) {
        return {
            return input()
        }
    }

    open func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<Token>] { return [] }
}

public typealias ServiceProvider = Provident.ServiceProvider
public typealias ServiceProviderCreationContext = Provident.ServiceProviderCreationContext
