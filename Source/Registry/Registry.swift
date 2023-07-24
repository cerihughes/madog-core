//
//  Created by Ceri Hughes on 19/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnyRegistry<T> = any Registry<T>

public protocol Registry<T> {
    associatedtype T

    func createViewController(from token: T, context: AnyContext<T>) -> ViewController?
}

/// A registry that looks up view controllers for a given Token <T>. This token should be a type that is able to
/// uniquely identify any VC, and also provide any data that the VC needs to be constructed.
///
/// The registry works by registering a number of functions. To retrieve a VC, the Token is passed into all
/// registered functions.
///
/// Note that registrants should make sure they don't "overlap" - if more than 1 registrant could potentially return a
/// VC for the same token, functions that register with a context will return first, and if there are still multiple,
/// the function that was registered first will return first.
class RegistryImplementation<T>: Registry {
    private var functions = [RegistryFunction]()

    typealias RegistryFunction = (T, AnyContext<T>) -> ViewController?

    func add(registryFunction: @escaping RegistryFunction) {
        functions.append(registryFunction)
    }

    func reset() {
        functions.removeAll()
    }

    func createViewController(from token: T, context: AnyContext<T>) -> ViewController? {
        for function in functions {
            if let result = function(token, context) {
                return result
            }
        }

        return nil
    }
}
