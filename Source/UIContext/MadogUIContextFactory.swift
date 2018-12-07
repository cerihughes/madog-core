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

class MadogUIContextFactoryImplementation: MadogUIContextFactory {
    private let registry: ViewControllerRegistry

    init(registry: ViewControllerRegistry) {
        self.registry = registry
    }

    func createSinglePageUI(_ uiIdentifier: SinglePageUIIdentifier) -> SinglePageUIContext? {
        if uiIdentifier == .navigationControllerIdentifier {
            return NavigationUI(registry: registry, factory: self)
        }

        return nil
    }

    func createMultiPageUI(_ uiIdentifier: MultiPageUIIdentifier) -> MultiPageUIContext? {
        if uiIdentifier == .tabBarControllerIdentifier {
            return TabBarNavigationUI(registry: registry, factory: self)
        }

        return nil
    }
}
