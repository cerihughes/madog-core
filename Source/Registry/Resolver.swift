//
//  Created by Ceri Hughes on 19/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias ServiceProviderFunction = (ServiceProviderCreationContext) -> ServiceProvider
public typealias ViewControllerProviderFunction<T> = () -> AnyViewControllerProvider<T>

public typealias AnyResolver<T> = any Resolver<T>

/// Implementations of Resolver should return arrays of functions that can create instances of ViewControllerProvider
/// and ServiceProvider, (e.g.) by manually instantiating the required implementations, or maybe loading them using
/// the objc-runtime (currently not working as ViewControllerProvider is a swift class that uses generics).
public protocol Resolver<T> {
    associatedtype T

    func serviceProviderFunctions() -> [ServiceProviderFunction]
    func viewControllerProviderFunctions() -> [ViewControllerProviderFunction<T>]
}

public extension Resolver {
    func serviceProviderFunctions() -> [ServiceProviderFunction] { [] }
}
