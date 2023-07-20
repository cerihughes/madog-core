//
//  MadogUIContainerFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias SingleVCUIRegistryFunction<T> = (Registry<T>, T) -> MadogModalUIContainer<T>?
public typealias MultiVCUIRegistryFunction<T> = (Registry<T>, [T]) -> MadogModalUIContainer<T>?
public typealias SplitSingleVCUIRegistryFunction<T> = (Registry<T>, T, T) -> MadogModalUIContainer<T>?
public typealias SplitMultiVCUIRegistryFunction<T> = (Registry<T>, T, [T]) -> MadogModalUIContainer<T>?

internal class MadogUIContainerFactory<T> {
    private let registry: Registry<T>
    private var singleVCUIRegistry = [String: SingleVCUIRegistryFunction<T>]()
    private var multiVCUIRegistry = [String: MultiVCUIRegistryFunction<T>]()
    private var splitSingleVCUIRegistry = [String: SplitSingleVCUIRegistryFunction<T>]()
    private var splitMultiVCUIRegistry = [String: SplitMultiVCUIRegistryFunction<T>]()

    internal init(registry: Registry<T>) {
        self.registry = registry

        _ = addUICreationFunction(identifier: basicIdentifier, function: BasicUI.init(registry:token:))
        _ = addUICreationFunction(identifier: navigationIdentifier, function: NavigationUI.init(registry:token:))
        _ = addUICreationFunction(identifier: tabBarIdentifier, function: TabBarUI.init(registry:tokens:))
        _ = addUICreationFunction(
            identifier: tabBarNavigationIdentifier,
            function: TabBarNavigationUI.init(registry:tokens:)
        )
    }

    internal func addUICreationFunction(identifier: String, function: @escaping SingleVCUIRegistryFunction<T>) -> Bool {
        guard singleVCUIRegistry[identifier] == nil else { return false }
        singleVCUIRegistry[identifier] = function
        return true
    }

    internal func addUICreationFunction(identifier: String, function: @escaping MultiVCUIRegistryFunction<T>) -> Bool {
        guard multiVCUIRegistry[identifier] == nil else { return false }
        multiVCUIRegistry[identifier] = function
        return true
    }

    internal func addUICreationFunction(
        identifier: String,
        function: @escaping SplitSingleVCUIRegistryFunction<T>
    ) -> Bool {
        guard splitSingleVCUIRegistry[identifier] == nil else { return false }
        splitSingleVCUIRegistry[identifier] = function
        return true
    }

    internal func addUICreationFunction(
        identifier: String,
        function: @escaping SplitMultiVCUIRegistryFunction<T>
    ) -> Bool {
        guard splitMultiVCUIRegistry[identifier] == nil else { return false }
        splitMultiVCUIRegistry[identifier] = function
        return true
    }

    internal func createUI<VC, TD>(
        identifier: MadogUIIdentifier<VC, TD>,
        tokenData: TD
    ) -> MadogModalUIContainer<T>? where VC: UIViewController, TD: TokenData {
        if let tokenData = tokenData as? SingleUITokenData, let token = tokenData.token as? T {
            return singleVCUIRegistry[identifier.value]?(registry, token)
        }
        if let tokenData = tokenData as? MultiUITokenData, let tokens = tokenData.tokens as? [T] {
            return multiVCUIRegistry[identifier.value]?(registry, tokens)
        }
        if let tokenData = tokenData as? SplitSingleUITokenData,
           let primaryToken = tokenData.primaryToken as? T,
           let secondaryToken = tokenData.secondaryToken as? T {
            return splitSingleVCUIRegistry[identifier.value]?(registry, primaryToken, secondaryToken)
        }
        if let tokenData = tokenData as? SplitMultiUITokenData,
           let primaryToken = tokenData.primaryToken as? T,
           let secondaryTokens = tokenData.secondaryTokens as? [T] {
            return splitMultiVCUIRegistry[identifier.value]?(registry, primaryToken, secondaryTokens)
        }
        return nil
    }
}
