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
    private var singlePageUIRegistry = [String: () -> MadogSinglePageUIContext<Token>]()
    private var multiPageUIRegistry = [String: () -> MadogMultiPageUIContext<Token>]()

    internal init(registry: ViewControllerRegistry) {
        self.registry = registry

        _ = addSinglePageUICreationFunction(identifier: navigationControllerIdentifier) { return NavigationUI<Token>() }
        _ = addMultiPageUICreationFunction(identifier: tabBarControllerIdentifier) { return TabBarNavigationUI<Token>() }
    }

    internal func addSinglePageUICreationFunction(identifier: String, function: @escaping () -> MadogSinglePageUIContext<Token>) -> Bool {
        guard singlePageUIRegistry[identifier] == nil else {
            return false
        }
        singlePageUIRegistry[identifier] = function
        return true
    }

    internal func addMultiPageUICreationFunction(identifier: String, function: @escaping () -> MadogMultiPageUIContext<Token>) -> Bool {
        guard multiPageUIRegistry[identifier] == nil else {
            return false
        }
        multiPageUIRegistry[identifier] = function
        return true
    }

    internal func createSinglePageUI<VC: UIViewController>(_ uiIdentifier: SinglePageUIIdentifier<VC>) -> MadogSinglePageUIContext<Token>? {
        guard let function = singlePageUIRegistry[uiIdentifier.value] else {
            return nil
        }

        let ui = function()
        ui.internalRegistry = registry
        return ui
    }

    internal func createMultiPageUI<VC: UIViewController>(_ uiIdentifier: MultiPageUIIdentifier<VC>) -> MadogMultiPageUIContext<Token>? {
        guard let function = multiPageUIRegistry[uiIdentifier.value] else {
            return nil
        }

        let ui = function()
        ui.internalRegistry = registry
        return ui
    }
}
