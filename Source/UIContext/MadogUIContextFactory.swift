//
//  MadogUIContextFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol MadogUIContextFactory {
    func createSinglePageUI(_ uiIdentifier: SinglePageUIIdentifier) -> (MadogUIContext & SinglePageContext)?
    func createMultiPageUI(_ uiIdentifier: MultiPageUIIdentifier) -> (MadogUIContext & MultiPageContext)?
}

internal class MadogUIContextFactoryImplementation: MadogUIContextFactory {
    private let registry: ViewControllerRegistry

    internal init(registry: ViewControllerRegistry) {
        self.registry = registry
    }

    internal func createSinglePageUI(_ uiIdentifier: SinglePageUIIdentifier) -> (MadogUIContext & SinglePageContext)? {
        if uiIdentifier == .navigationControllerIdentifier {
            return NavigationUI(registry: registry, factory: self)
        }

        return nil
    }

    internal func createMultiPageUI(_ uiIdentifier: MultiPageUIIdentifier) -> (MadogUIContext & MultiPageContext)? {
        if uiIdentifier == .tabBarControllerIdentifier {
            return TabBarNavigationUI(registry: registry, factory: self)
        }

        return nil
    }
}
