//
//  MadogUIContainerFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias MadogRegistryFunction<Token, TokenData> = (Registry<Token>, TokenData) -> MadogModalUIContainer<Token>?

public typealias SingleVCUIRegistryFunction<Token> = MadogRegistryFunction<Token, SingleUITokenData<Token>>
public typealias MultiVCUIRegistryFunction<Token> = MadogRegistryFunction<Token, MultiUITokenData<Token>>
public typealias SplitSingleVCUIRegistryFunction<Token> = MadogRegistryFunction<Token, SplitSingleUITokenData<Token>>
public typealias SplitMultiVCUIRegistryFunction<Token> = MadogRegistryFunction<Token, SplitMultiUITokenData<Token>>

internal class MadogUIContainerFactory<Token> {
    private let registry: Registry<Token>
    private var singleVCUIRegistry = [String: SingleVCUIRegistryFunction<Token>]()
    private var multiVCUIRegistry = [String: MultiVCUIRegistryFunction<Token>]()
    private var splitSingleVCUIRegistry = [String: SplitSingleVCUIRegistryFunction<Token>]()
    private var splitMultiVCUIRegistry = [String: SplitMultiVCUIRegistryFunction<Token>]()

    internal init(registry: Registry<Token>) {
        self.registry = registry

        _ = addUICreationFunction(identifier: basicIdentifier) { BasicUI<Token>(registry: $0, tokenData: $1) }
        _ = addUICreationFunction(identifier: navigationIdentifier) { NavigationUI<Token>(registry: $0, tokenData: $1) }
        _ = addUICreationFunction(identifier: tabBarIdentifier) { TabBarUI<Token>(registry: $0, tokenData: $1) }
        _ = addUICreationFunction(identifier: tabBarNavigationIdentifier) { TabBarNavigationUI<Token>(registry: $0, tokenData: $1) }
    }

    internal func addUICreationFunction(identifier: String, function: @escaping SingleVCUIRegistryFunction<Token>) -> Bool {
        guard singleVCUIRegistry[identifier] == nil else {
            return false
        }
        singleVCUIRegistry[identifier] = function
        return true
    }

    internal func addUICreationFunction(identifier: String, function: @escaping MultiVCUIRegistryFunction<Token>) -> Bool {
        guard multiVCUIRegistry[identifier] == nil else {
            return false
        }
        multiVCUIRegistry[identifier] = function
        return true
    }

    internal func addUICreationFunction(identifier: String, function: @escaping SplitSingleVCUIRegistryFunction<Token>) -> Bool {
        guard splitSingleVCUIRegistry[identifier] == nil else {
            return false
        }
        splitSingleVCUIRegistry[identifier] = function
        return true
    }

    internal func addUICreationFunction(identifier: String, function: @escaping SplitMultiVCUIRegistryFunction<Token>) -> Bool {
        guard splitMultiVCUIRegistry[identifier] == nil else {
            return false
        }
        splitMultiVCUIRegistry[identifier] = function
        return true
    }

    internal func createUI<VC: UIViewController>(identifier: MadogUIIdentifier<VC>, tokenData: TokenData) -> MadogModalUIContainer<Token>? {
        if let tokenData = tokenData as? SingleUITokenData<Token> {
            return singleVCUIRegistry[identifier.value]?(registry, tokenData)
        }
        if let tokenData = tokenData as? MultiUITokenData<Token> {
            return multiVCUIRegistry[identifier.value]?(registry, tokenData)
        }
        if let tokenData = tokenData as? SplitSingleUITokenData<Token> {
            return splitSingleVCUIRegistry[identifier.value]?(registry, tokenData)
        }
        if let tokenData = tokenData as? SplitMultiUITokenData<Token> {
            return splitMultiVCUIRegistry[identifier.value]?(registry, tokenData)
        }
        return nil
    }
}
