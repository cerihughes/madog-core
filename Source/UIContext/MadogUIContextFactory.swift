//
//  MadogUIContextFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol SinglePageUIContext: MadogUIContext, SinglePageContext {}
internal protocol MultiPageUIContext: MadogUIContext, MultiPageContext {}

internal protocol MadogUIContextFactory {
    func createSinglePageUI(_ uiIdentifier: SinglePageUIIdentifier) -> SinglePageUIContext?
    func createMultiPageUI(_ uiIdentifier: MultiPageUIIdentifier) -> MultiPageUIContext?
}

internal class MadogUIContextFactoryImplementation: MadogUIContextFactory {
    private let registry: ViewControllerRegistry

    internal init(registry: ViewControllerRegistry) {
        self.registry = registry
    }

    internal func createSinglePageUI(_ uiIdentifier: SinglePageUIIdentifier) -> SinglePageUIContext? {
        if uiIdentifier == .navigationControllerIdentifier {
            return NavigationUI(registry: registry, factory: self)
        }

        return nil
    }

    internal func createMultiPageUI(_ uiIdentifier: MultiPageUIIdentifier) -> MultiPageUIContext? {
        if uiIdentifier == .tabBarControllerIdentifier {
            return TabBarNavigationUI(registry: registry, factory: self)
        }

        return nil
    }
}
