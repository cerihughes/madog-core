//
//  MadogUIContainerFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

public typealias BasicUIContext = Context & ModalContext
public typealias NavigationUIContext = BasicUIContext & ForwardBackNavigationContext
public typealias TabBarUIContext = BasicUIContext & MultiContext
public typealias TabBarNavigationUIContext = TabBarUIContext & ForwardBackNavigationContext

internal class MadogUIContainerFactory<Token> {
    private let registry: Registry<Token>
    private var singleVCUIRegistry = [String: SingleVCUIRegistryFunction<Token>]()
    private var multiVCUIRegistry = [String: MultiVCUIRegistryFunction<Token>]()
    private var splitSingleVCUIRegistry = [String: SplitSingleVCUIRegistryFunction<Token>]()
    private var splitMultiVCUIRegistry = [String: SplitMultiVCUIRegistryFunction<Token>]()

    internal init(registry: Registry<Token>) {
        self.registry = registry

        _ = addSingleUICreationFunction(identifier: basicIdentifier) { BasicUI<Token>(registry: $0, token: $1) }
        _ = addSingleUICreationFunction(identifier: navigationIdentifier) { NavigationUI<Token>(registry: $0, token: $1) }
        _ = addMultiUICreationFunction(identifier: tabBarIdentifier) { TabBarUI<Token>(registry: $0, tokens: $1) }
        _ = addMultiUICreationFunction(identifier: tabBarNavigationIdentifier) { TabBarNavigationUI<Token>(registry: $0, tokens: $1) }
    }

    internal func addSingleUICreationFunction(identifier: String, function: @escaping SingleVCUIRegistryFunction<Token>) -> Bool {
        guard singleVCUIRegistry[identifier] == nil else {
            return false
        }
        singleVCUIRegistry[identifier] = function
        return true
    }

    internal func addMultiUICreationFunction(identifier: String, function: @escaping MultiVCUIRegistryFunction<Token>) -> Bool {
        guard multiVCUIRegistry[identifier] == nil else {
            return false
        }
        multiVCUIRegistry[identifier] = function
        return true
    }

    internal func addSplitSingleUICreationFunction(identifier: String, function: @escaping SplitSingleVCUIRegistryFunction<Token>) -> Bool {
        guard splitSingleVCUIRegistry[identifier] == nil else {
            return false
        }
        splitSingleVCUIRegistry[identifier] = function
        return true
    }

    internal func addSplitMultiUICreationFunction(identifier: String, function: @escaping SplitMultiVCUIRegistryFunction<Token>) -> Bool {
        guard splitMultiVCUIRegistry[identifier] == nil else {
            return false
        }
        splitMultiVCUIRegistry[identifier] = function
        return true
    }

    internal func createSingleUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>, token: Token) -> MadogModalUIContainer<Token>? {
        singleVCUIRegistry[identifier.value]?(registry, token)
    }

    internal func createMultiUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>, tokens: [Token]) -> MadogModalUIContainer<Token>? {
        multiVCUIRegistry[identifier.value]?(registry, tokens)
    }

    internal func createSplitSingleUI<VC: UIViewController>(identifier: SplitSingleUIIdentifier<VC>,
                                                            primaryToken: Token,
                                                            secondaryToken: Token) -> MadogModalUIContainer<Token>? {
        splitSingleVCUIRegistry[identifier.value]?(registry, primaryToken, secondaryToken)
    }

    internal func createSplitMultiUI<VC: UIViewController>(identifier: SplitMultiUIIdentifier<VC>,
                                                           primaryToken: Token,
                                                           secondaryTokens: [Token]) -> MadogModalUIContainer<Token>? {
        splitMultiVCUIRegistry[identifier.value]?(registry, primaryToken, secondaryTokens)
    }
}
