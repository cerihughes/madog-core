//
//  Page2.swift
//  MadogSample
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

fileprivate let page2Identifier = "page2Identifier"

class Page2: PageFactory, StatefulPage {
    private var state1: State1?
    private var state2: State2?
    private var uuid: UUID?

    // MARK: PageFactory

    static func createPage() -> Page {
        return Page2()
    }

    // MARK: Page

    func configure(with state: [String : State]) {
        state1 = state[state1Name] as? State1
        state2 = state[state2Name] as? State2
    }

    func register<Token>(with registry: ViewControllerRegistry<Token>) {
        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    func unregister<Token>(from registry: ViewControllerRegistry<Token>) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    // MARK: Private

    private func createViewController<Token, Context>(token: Token, context: Context) -> UIViewController? {
        guard let state1 = state1,
            let state2 = state2,
            let rl = token as? ResourceLocator,
            rl.identifier == page2Identifier,
            let pageData = rl.pageData,
            let navigationContext = context as? NavigationContext else {
            return nil
        }

        return Page2ViewController(state1: state1,
                                   state2: state2,
                                   pageData: pageData,
                                   navigationContext: navigationContext)
    }
}

extension ResourceLocator {
    private static let pageDataKey = "pageData"

    static func createPage2ResourceLocator(pageData: String) -> ResourceLocator {
        return ResourceLocator(identifier: page2Identifier, data: [pageDataKey : pageData])
    }

    var pageData: String? {
        return data[ResourceLocator.pageDataKey] as? String
    }
}
