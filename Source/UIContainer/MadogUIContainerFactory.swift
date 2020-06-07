//
//  MadogUIContainerFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias SingleVCUIRegistryFunction<Token> = (Registry<Token>, Token) -> MadogModalUIContainer<Token>?
public typealias MultiVCUIRegistryFunction<Token> = (Registry<Token>, [Token]) -> MadogModalUIContainer<Token>?
public typealias SplitSingleVCUIRegistryFunction<Token> = (Registry<Token>, Token, Token) -> MadogModalUIContainer<Token>?
public typealias SplitMultiVCUIRegistryFunction<Token> = (Registry<Token>, Token, [Token]) -> MadogModalUIContainer<Token>?

internal class MadogUIContainerFactory<Token> {
    private let registry: Registry<Token>
    private var singleVCUIRegistry = [String: SingleVCUIRegistryFunction<Token>]()
    private var multiVCUIRegistry = [String: MultiVCUIRegistryFunction<Token>]()
    private var splitSingleVCUIRegistry = [String: SplitSingleVCUIRegistryFunction<Token>]()
    private var splitMultiVCUIRegistry = [String: SplitMultiVCUIRegistryFunction<Token>]()

    internal init(registry: Registry<Token>) {
        self.registry = registry

        _ = addUICreationFunction(identifier: basicIdentifier, function: BasicUI.init(registry:token:))
        _ = addUICreationFunction(identifier: navigationIdentifier, function: NavigationUI.init(registry:token:))
        _ = addUICreationFunction(identifier: tabBarIdentifier, function: TabBarUI.init(registry:tokens:))
        _ = addUICreationFunction(identifier: tabBarNavigationIdentifier, function: TabBarNavigationUI.init(registry:tokens:))
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
        if let tokenData = tokenData as? SingleUITokenData, let token = tokenData.token as? Token {
            return singleVCUIRegistry[identifier.value]?(registry, token)
        }
        if let tokenData = tokenData as? MultiUITokenData, let tokens = tokenData.tokens as? [Token] {
            return multiVCUIRegistry[identifier.value]?(registry, tokens)
        }
        if let tokenData = tokenData as? SplitSingleUITokenData,
            let primaryToken = tokenData.primaryToken as? Token,
            let secondaryToken = tokenData.secondaryToken as? Token {
            return splitSingleVCUIRegistry[identifier.value]?(registry, primaryToken, secondaryToken)
        }
        if let tokenData = tokenData as? SplitMultiUITokenData,
            let primaryToken = tokenData.primaryToken as? Token,
            let secondaryTokens = tokenData.secondaryTokens as? [Token] {
            return splitMultiVCUIRegistry[identifier.value]?(registry, primaryToken, secondaryTokens)
        }
        return nil
    }
}
