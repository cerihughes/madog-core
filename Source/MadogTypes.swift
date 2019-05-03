//
//  MadogTypes.swift
//  Madog
//
//  Created by Ceri Hughes on 03/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Registry

public class ViewControllerRegistry<Token>: Registry.ViewControllerRegistry<Token, Context> {}

open class ViewControllerProvider<Token>: Registry.ViewControllerProvider<Token, Context> {
    override public final func register(with registry: Registry.ViewControllerRegistry<Token, Context>) {
        guard let registry = registry as? ViewControllerRegistry else {
            return
        }

        register(with: registry)
    }

    override public final func unregister(from registry: Registry.ViewControllerRegistry<Token, Context>) {
        guard let registry = registry as? ViewControllerRegistry else {
            return
        }

        unregister(from: registry)
    }

    open func register(with registry: ViewControllerRegistry<Token>) {}
    open func unregister(from registry: ViewControllerRegistry<Token>) {}
}

open class Resolver<Token>: Registry.Resolver<Token, Context> {
    override public final func viewControllerProviderCreationFunctions() -> [() -> Registry.ViewControllerProvider<Token, Context>] {
        let functions: [() -> ViewControllerProvider<Token>] = viewControllerProviderCreationFunctions()
        return functions.map(convert)
    }

    private func convert(input: @escaping () -> ViewControllerProvider<Token>) -> (() -> Registry.ViewControllerProvider<Token, Context>) {
        return {
            return input()
        }
    }

    open func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<Token>] { return [] }
}

public typealias ServiceProvider = Registry.ServiceProvider
public typealias ServiceProviderCreationContext = Registry.ServiceProviderCreationContext
