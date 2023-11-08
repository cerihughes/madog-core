//
//  Created by Ceri Hughes on 19/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation
import Provident

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

extension Resolver {
    func bridged() -> Provident.AnyResolver<T, AnyContainer<T>> {
        ResolverBridge(bridged: self)
    }
}

class ResolverBridge<T>: Provident.Resolver {
    typealias C = AnyContainer<T>

    private let bridged: AnyResolver<T>

    init(bridged: AnyResolver<T>) {
        self.bridged = bridged
    }

    func serviceProviderFunctions() -> [Provident.ServiceProviderFunction] {
        bridged.serviceProviderFunctions()
    }

    func viewControllerProviderFunctions() -> [Provident.ViewControllerProviderFunction<T, C>] {
        bridged.viewControllerProviderFunctions().map {
            Self.bridge(madog: $0)
        }
    }

    static func bridge(
        madog: @escaping ViewControllerProviderFunction<T>
    ) -> Provident.ViewControllerProviderFunction<T, C> {
        { madog().bridged() }
    }
}
