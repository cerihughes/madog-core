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

        singlePageUIRegistry[navigationControllerIdentifier] = { return NavigationUI<Token>() }
        multiPageUIRegistry[tabBarControllerIdentifier] = { return TabBarNavigationUI<Token>() }
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
