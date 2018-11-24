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
    private var pages = [Page]()

    internal func registerPages<Token, Context>(with registry: ViewControllerRegistry<Token, Context>, pageResolver: PageResolver) {
        let pageFactories = pageResolver.pageFactories()
        for pageFactory in pageFactories {
            let page = pageFactory.createPage()
            page.register(with: registry)
            pages.append(page)
        }
    }

    internal func unregisterPages<Token, Context>(from registry: ViewControllerRegistry<Token, Context>) {
        for page in pages {
            page.unregister(from: registry)
        }
    }
}
