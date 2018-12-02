//
//  Factory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

protocol Factory {
    func createSinglePageUI(_ ui: SinglePageUI) -> SinglePageContext?
    func createMultiPageUI(_ ui: MultiPageUI) -> MultiPageContext?
}

class MadogFactory<Token>: Factory {
    private let registry: ViewControllerRegistry<Token>

    init(registry: ViewControllerRegistry<Token>) {
        self.registry = registry
    }

    func createSinglePageUI(_ ui: SinglePageUI) -> SinglePageContext? {
        if ui.value == SinglePageUI.navigationController.value {
            return NavigationUI<Token>(registry: registry, factory: self)
        }

        return nil
    }

    func createMultiPageUI(_ ui: MultiPageUI) -> MultiPageContext? {
        if ui.value == MultiPageUI.tabBarController.value {
            return TabBarNavigationUI<Token>(registry: registry, factory: self)
        }
        
        return nil
    }
}
