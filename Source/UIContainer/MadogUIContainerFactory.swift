//
//  MadogUIContainerFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Registry
import UIKit

internal class MadogUIContainerFactory<Token> {
    private let registry: Registry.ViewControllerRegistry<Token, Context>
    private var singleVCUIRegistry = [String: () -> MadogSingleUIContainer<Token>]()
    private var multiVCUIRegistry = [String: () -> MadogMultiUIContainer<Token>]()

    internal init(registry: Registry.ViewControllerRegistry<Token, Context>) {
        self.registry = registry

        _ = addSingleUICreationFunction(identifier: navigationControllerIdentifier) { return NavigationUI<Token>() }
        _ = addMultiUICreationFunction(identifier: tabBarControllerIdentifier) { return TabBarNavigationUI<Token>() }
    }

    internal func addSingleUICreationFunction(identifier: String, function: @escaping () -> MadogSingleUIContainer<Token>) -> Bool {
        guard singleVCUIRegistry[identifier] == nil else {
            return false
        }
        singleVCUIRegistry[identifier] = function
        return true
    }

    internal func addMultiUICreationFunction(identifier: String, function: @escaping () -> MadogMultiUIContainer<Token>) -> Bool {
        guard multiVCUIRegistry[identifier] == nil else {
            return false
        }
        multiVCUIRegistry[identifier] = function
        return true
    }

    internal func createSingleUI<VC: UIViewController>(identifier: SingleUIIdentifier<VC>) -> MadogSingleUIContainer<Token>? {
        guard let function = singleVCUIRegistry[identifier.value] else {
            return nil
        }

        let ui = function()
        ui.internalRegistry = registry
        return ui
    }

    internal func createMultiUI<VC: UIViewController>(identifier: MultiUIIdentifier<VC>) -> MadogMultiUIContainer<Token>? {
        guard let function = multiVCUIRegistry[identifier.value] else {
            return nil
        }

        let ui = function()
        ui.internalRegistry = registry
        return ui
    }
}
