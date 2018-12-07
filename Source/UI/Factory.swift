//
//  Factory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

protocol Factory {
    func createSinglePageUI(_ uiIdentifier: SinglePageUIIdentifier) -> SinglePageContextUI?
    func createMultiPageUI(_ uiIdentifier: MultiPageUIIdentifier) -> MultiPageContextUI?
}

class MadogFactory<Token>: Factory {
    private let registry: ViewControllerRegistry<Token>

    init(registry: ViewControllerRegistry<Token>) {
        self.registry = registry
    }

    func createSinglePageUI(_ uiIdentifier: SinglePageUIIdentifier) -> SinglePageContextUI? {
        if uiIdentifier == .navigationControllerIdentifier {
            return NavigationUI<Token>(registry: registry, factory: self)
        }

        return nil
    }

    func createMultiPageUI(_ uiIdentifier: MultiPageUIIdentifier) -> MultiPageContextUI? {
        if uiIdentifier == .tabBarControllerIdentifier {
            return TabBarNavigationUI<Token>(registry: registry, factory: self)
        }
        
        return nil
    }
}
