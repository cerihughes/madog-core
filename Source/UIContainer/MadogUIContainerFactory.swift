//
//  MadogUIContainerFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias MadogRegistryFunction<Token, TokenData> = (Registry<Token>, TokenData) -> MadogModalUIContainer<Token>?

public typealias SingleVCUIRegistryFunction<Token> = MadogRegistryFunction<Token, SingleUITokenData>
public typealias MultiVCUIRegistryFunction<Token> = MadogRegistryFunction<Token, MultiUITokenData>
public typealias SplitSingleVCUIRegistryFunction<Token> = MadogRegistryFunction<Token, SplitSingleUITokenData>
public typealias SplitMultiVCUIRegistryFunction<Token> = MadogRegistryFunction<Token, SplitMultiUITokenData>

internal class MadogUIContainerFactory<Token> {
    private let registry: Registry<Token>
    private var singleVCUIRegistry = [String: SingleVCUIRegistryFunction<Token>]()
    private var multiVCUIRegistry = [String: MultiVCUIRegistryFunction<Token>]()
    private var splitSingleVCUIRegistry = [String: SplitSingleVCUIRegistryFunction<Token>]()
    private var splitMultiVCUIRegistry = [String: SplitMultiVCUIRegistryFunction<Token>]()

    internal init(registry: Registry<Token>) {
        self.registry = registry

        _ = addUICreationFunction(identifier: basicIdentifier, function: BasicUI<Token>.init(registry:tokenData:))
        _ = addUICreationFunction(identifier: navigationIdentifier, function: NavigationUI<Token>.init(registry:tokenData:))
        _ = addUICreationFunction(identifier: tabBarIdentifier, function: TabBarUI<Token>.init(registry:tokenData:))
        _ = addUICreationFunction(identifier: tabBarNavigationIdentifier, function: TabBarNavigationUI<Token>.init(registry:tokenData:))
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

    internal func createUI<VC, TD>(identifier: MadogUIIdentifier<VC, TD>,
                                   tokenData: TD) -> MadogModalUIContainer<Token>? where VC: UIViewController, TD: TokenData {
        if let tokenData = tokenData as? SingleUITokenData {
            return singleVCUIRegistry[identifier.value]?(registry, tokenData)
        }
        if let tokenData = tokenData as? MultiUITokenData {
            return multiVCUIRegistry[identifier.value]?(registry, tokenData)
        }
        if let tokenData = tokenData as? SplitSingleUITokenData {
            return splitSingleVCUIRegistry[identifier.value]?(registry, tokenData)
        }
        if let tokenData = tokenData as? SplitMultiUITokenData {
            return splitMultiVCUIRegistry[identifier.value]?(registry, tokenData)
        }
        return nil
    }
}
