//
//  ViewControllerRegistry.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

/// A registry that looks up view controllers for a given Token <T>. This token should be a type that is able to uniquely
/// identify any VC, and also provide any data that the VC needs to be constructed.
///
/// The registry works by registering a number of functions. To retrieve a VC, the Token is passed into all
/// registered functions along with an optional Context <C>. The context isn't "optional" in the traditional (C?) sense -
/// instead there are 2 creation functions - 1 that uses a C, and one that doesn't. The 1st non-nil VC that comes back
/// is used as the return value.
///
/// Note that registrants should make sure they don't "overlap" - if more than 1 registrant could potentially return a
/// VC for the same token, functions that register with a context will return first, and if there are still multiple,
/// the function that was registered first will return first.
public class ViewControllerRegistry<T, C> {
    public typealias RegistryFunction = (T) -> UIViewController?
    public typealias RegistryFunctionWithContext = (T, C) -> UIViewController?

    private var orderedFunctionUUIDs = [UUID]()
    private var orderedFunctions = [RegistryFunction]()

    private var orderedFunctionWithContextUUIDs = [UUID]()
    private var orderedFunctionsWithContext = [RegistryFunctionWithContext]()

    public init() {}

    public func add(registryFunction: @escaping RegistryFunction) -> UUID {
        let uuid = UUID()
        orderedFunctionUUIDs.append(uuid)
        orderedFunctions.append(registryFunction)
        return uuid
    }

    public func add(registryFunctionWithContext: @escaping RegistryFunctionWithContext) -> UUID {
        let uuid = UUID()
        orderedFunctionWithContextUUIDs.append(uuid)
        orderedFunctionsWithContext.append(registryFunctionWithContext)
        return uuid
    }

    public func removeRegistryFunction(uuid: UUID) {
        if let index = orderedFunctionUUIDs.index(of: uuid) {
            _ = orderedFunctionUUIDs.remove(at: index)
            _ = orderedFunctions.remove(at: index)
        }
        if let index = orderedFunctionWithContextUUIDs.index(of: uuid) {
            _ = orderedFunctionWithContextUUIDs.remove(at: index)
            _ = orderedFunctionsWithContext.remove(at: index)
        }
    }

    public func createViewController(from token: T, context: C? = nil) -> UIViewController? {
        if let context = context {
            for function in orderedFunctionsWithContext {
                if let result = function(token, context) {
                    return result
                }
            }
        }

        for function in orderedFunctions {
            if let result = function(token) {
                return result
            }
        }

        return nil
    }
}
