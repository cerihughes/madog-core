//
//  MadogUIContextFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol MadogUIContextFactory {
    func createSinglePageUI<VC: UIViewController>(_ uiIdentifier: SinglePageUIIdentifier<VC>) -> MadogSinglePageUIContext?
    func createMultiPageUI<VC: UIViewController>(_ uiIdentifier: MultiPageUIIdentifier<VC>) -> MadogMultiPageUIContext?
}

internal class MadogUIContextFactoryImplementation: MadogUIContextFactory {
    private let registry: ViewControllerRegistry

    internal init(registry: ViewControllerRegistry) {
        self.registry = registry
    }

    internal func createSinglePageUI<VC: UIViewController>(_ uiIdentifier: SinglePageUIIdentifier<VC>) -> MadogSinglePageUIContext? {
        if uiIdentifier.value == navigationControllerIdentifier {
            return NavigationUI(registry: registry, factory: self)
        }

        return nil
    }

    internal func createMultiPageUI<VC: UIViewController>(_ uiIdentifier: MultiPageUIIdentifier<VC>) -> MadogMultiPageUIContext? {
        if uiIdentifier.value == tabBarControllerIdentifier {
            return TabBarNavigationUI(registry: registry, factory: self)
        }

        return nil
    }
}
