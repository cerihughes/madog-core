//
//  BaseUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

/// A class that presents view controllers, and manages the navigation between them.
public class BaseUI {
    internal var states = [String:State]()
    internal var pages = [Page]()

    internal func loadState(stateResolver: StateResolver) {
        let stateFactories = stateResolver.stateFactories()
        for stateFactory in stateFactories {
            let state = stateFactory.createState()
            let name = state.name
            states[name] = state
        }
    }

    internal func registerPages<Token>(with registry: ViewControllerRegistry<Token>, pageResolver: PageResolver) {
        let pageFactories = pageResolver.pageFactories()
        for pageFactory in pageFactories {
            let page = pageFactory.createPage()
            page.register(with: registry)
            if let statefulPage = page as? StatefulPage {
                statefulPage.configure(with: states)
            }
            pages.append(page)
        }
    }

    internal func unregisterPages<Token>(from registry: ViewControllerRegistry<Token>) {
        for page in pages {
            page.unregister(from: registry)
        }
        pages.removeAll()
    }
}
