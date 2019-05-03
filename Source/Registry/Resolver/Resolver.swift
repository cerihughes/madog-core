//
//  Resolver.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

/// Subclasses of Resolver should return arrays of functions that can create instances of ViewControllerProvider
/// and ServiceProvider, (e.g.) by manually instantiating the required implementations, or maybe loading them using
/// the objc-runtime (currently not working as ViewControllerProvider is a swift class that uses generics).
open class Resolver<T, C> {
    public init() {}
    open func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<T, C>] { return [] }
    open func serviceProviderCreationFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] { return [] }
}
