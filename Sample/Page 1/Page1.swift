//
//  Page1.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class Page1: PageFactory, StatefulPage {
    private var state1: State1?
    private var uuid: UUID?

    // MARK: PageFactory

    static func createPage() -> Page {
        return Page1()
    }

    // MARK: Page

    func configure(with state: [String : State]) {
        state1 = state[state1Name] as? State1
    }

    func register<Token>(with registry: ViewControllerRegistry<Token>) {
        uuid = registry.add(initialRegistryFunction: createViewController(context:))
    }

    func unregister<Token>(from registry: ViewControllerRegistry<Token>) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    // MARK: Private

    private func createViewController(context: Context) -> UIViewController? {
        guard let state1 = state1,
            let navigationContext = context as? NavigationContext else {
            return nil
        }

        return Page1ViewController(state1: state1,
                                   navigationContext: navigationContext)
    }
}
