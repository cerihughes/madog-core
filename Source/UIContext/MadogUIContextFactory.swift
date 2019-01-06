//
//  MadogUIContextFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal class MadogUIContextFactory<Token> {
    private let registry: ViewControllerRegistry
    private var singleVCUIRegistry = [String: () -> MadogSingleUIContext<Token>]()
    private var multiVCUIRegistry = [String: () -> MadogMultiUIContext<Token>]()

    internal init(registry: ViewControllerRegistry) {
        self.registry = registry

        _ = addSingleUICreationFunction(identifier: navigationControllerIdentifier) { return NavigationUI<Token>() }
        _ = addMultiUICreationFunction(identifier: tabBarControllerIdentifier) { return TabBarNavigationUI<Token>() }
    }

    internal func addSingleUICreationFunction(identifier: String, function: @escaping () -> MadogSingleUIContext<Token>) -> Bool {
        guard singleVCUIRegistry[identifier] == nil else {
            return false
        }
        singleVCUIRegistry[identifier] = function
        return true
    }

    internal func addMultiUICreationFunction(identifier: String, function: @escaping () -> MadogMultiUIContext<Token>) -> Bool {
        guard multiVCUIRegistry[identifier] == nil else {
            return false
        }
        multiVCUIRegistry[identifier] = function
        return true
    }

    internal func createSingleUI<VC: UIViewController>(_ uiIdentifier: SingleUIIdentifier<VC>) -> MadogSingleUIContext<Token>? {
        guard let function = singleVCUIRegistry[uiIdentifier.value] else {
            return nil
        }

        let ui = function()
        ui.internalRegistry = registry
        return ui
    }

    internal func createMultiUI<VC: UIViewController>(_ uiIdentifier: MultiUIIdentifier<VC>) -> MadogMultiUIContext<Token>? {
        guard let function = multiVCUIRegistry[uiIdentifier.value] else {
            return nil
        }

        let ui = function()
        ui.internalRegistry = registry
        return ui
    }
}
