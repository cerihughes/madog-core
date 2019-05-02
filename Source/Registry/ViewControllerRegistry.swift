//
//  ViewControllerRegistry.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

/// A registry that looks up view controllers for a given <Token>. This token should be a type that is able to uniquely
/// identify any VC, and also provide any data that the VC needs to be constructed.
///
/// The registry works by registering a number of functions. To retrieve a VC, the <Token> is passed into all
/// registered functions along with the <Context>, and the 1st non-nil VC that comes back is used as the return value.
///
/// Note that registrants should make sure they don't "overlap" - if more than 1 registrant could potentially return a
/// VC for the same token, behaviour is undefined - there's no guarantee which will be returned first.
public class ViewControllerRegistry: NSObject {
    public typealias RegistryFunction = (Any, Context?) -> UIViewController?

    private var registry: [UUID:RegistryFunction] = [:]

    public func add(registryFunction: @escaping RegistryFunction) -> UUID {
        let uuid = UUID()
        registry[uuid] = registryFunction
        return uuid
    }

    public func removeRegistryFunction(uuid: UUID) {
        registry.removeValue(forKey: uuid)
    }

    public func createViewController(from token: Any, context: Context?) -> UIViewController? {
        for function in registry.values {
            if let result = function(token, context) {
                return result
            }
        }
        return nil
    }
}
