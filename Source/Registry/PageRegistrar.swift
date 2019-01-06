//
//  PageRegistrar.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

/// A class that presents view controllers, and manages the navigation between them.
internal class PageRegistrar {
    internal var states = [String:State]()
    internal var pages = [Page]()

    internal func createState(functions: [StateCreationFunction]) {
        for function in functions {
            let state = function()
            let name = state.name
            states[name] = state
        }
    }

    internal func registerPages(with registry: ViewControllerRegistry, functions: [PageCreationFunction]) {
        for function in functions {
            let page = function()
            page.register(with: registry)
            page.configure(with: states)
            pages.append(page)
        }
    }

    internal func unregisterPages(from registry: ViewControllerRegistry) {
        for page in pages {
            page.unregister(from: registry)
        }
        pages.removeAll()
    }
}
