//
//  Registry.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

/// A registry that looks up <Result> objects for a given <Token>. This token should be a type that is able to uniquely
/// identify any object, and also provide any data that <Result> needs to be constructed.
///
/// The registry works by registering a number of functions. To retrieve a <Result>, the <Token> is passed into
/// all registered functions along with the <Context>, and the 1st non-nil <Result> that comes back is used as the return
/// value.
///
/// Note that registrants should make sure they don't "overlap" - if more than 1 registrant could potentially return an
/// object for the same token, behaviour is undefined - there's no guarantee which will be returned first.
class Registry<Token, Context, Result>: NSObject {
    typealias GlobalRegistryFunction = (Context) -> Result
    typealias RegistryFunction = (Token, Context) -> Result?

    private var globalRegistry: [UUID:GlobalRegistryFunction] = [:]
    private var registry: [UUID:RegistryFunction] = [:]

    func add(globalRegistryFunction: @escaping GlobalRegistryFunction) -> UUID {
        let uuid = UUID()
        globalRegistry[uuid] = globalRegistryFunction
        return uuid
    }

    func add(registryFunction: @escaping RegistryFunction) -> UUID {
        let uuid = UUID()
        registry[uuid] = registryFunction
        return uuid
    }

    func removeGlobalRegistryFunction(uuid: UUID) {
        globalRegistry.removeValue(forKey: uuid)
    }

    func removeRegistryFunction(token: UUID) {
        registry.removeValue(forKey: token)
    }

    func createGlobalResults(context: Context) -> [Result] {
        guard globalRegistry.count > 0 else {
            return []
        }

        return globalRegistry.values.map { $0(context) }
    }

    func createResult(from token: Token, context: Context) -> Result? {
        for function in registry.values {
            if let result = function(token, context) {
                return result
            }
        }
        return nil
    }
}
