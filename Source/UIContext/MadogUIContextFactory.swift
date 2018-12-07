//
//  MadogUIContextFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

protocol SinglePageUIContext: MadogUIContext, SinglePageContext {}
protocol MultiPageUIContext: MadogUIContext, MultiPageContext {}

protocol MadogUIContextFactory {
    func createSinglePageUI(_ uiIdentifier: SinglePageUIIdentifier) -> SinglePageUIContext?
    func createMultiPageUI(_ uiIdentifier: MultiPageUIIdentifier) -> MultiPageUIContext?
}

class MadogUIContextFactoryImplementation<Token>: MadogUIContextFactory {
    private let registry: ViewControllerRegistry<Token>

    init(registry: ViewControllerRegistry<Token>) {
        self.registry = registry
    }

    func createSinglePageUI(_ uiIdentifier: SinglePageUIIdentifier) -> SinglePageUIContext? {
        if uiIdentifier == .navigationControllerIdentifier {
            return NavigationUI<Token>(registry: registry, factory: self)
        }

        return nil
    }

    func createMultiPageUI(_ uiIdentifier: MultiPageUIIdentifier) -> MultiPageUIContext? {
        if uiIdentifier == .tabBarControllerIdentifier {
            return TabBarNavigationUI<Token>(registry: registry, factory: self)
        }
        
        return nil
    }
}
