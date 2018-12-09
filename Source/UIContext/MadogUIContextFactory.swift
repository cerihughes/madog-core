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

    internal init(registry: ViewControllerRegistry) {
        self.registry = registry
    }

    internal func createSinglePageUI<VC: UIViewController>(_ uiIdentifier: SinglePageUIIdentifier<VC>) -> MadogSinglePageUIContext<Token>? {
        if uiIdentifier.value == navigationControllerIdentifier {
            return NavigationUI<Token>(registry: registry, factory: self)
        }

        return nil
    }

    internal func createMultiPageUI<VC: UIViewController>(_ uiIdentifier: MultiPageUIIdentifier<VC>) -> MadogMultiPageUIContext<Token>? {
        if uiIdentifier.value == tabBarControllerIdentifier {
            return TabBarNavigationUI<Token>(registry: registry, factory: self)
        }

        return nil
    }
}
