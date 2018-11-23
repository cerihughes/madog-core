//
//  BaseUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

/// A class that presents view controllers, and manages the navigation between them.
public class BaseUI<Token, Context> {
    internal let registry = ViewControllerRegistry<Token, Context>()
    internal let pages: [Page]

    public init?(pageResolver: PageResolver) {
        var pages = [Page]()
        let pageFactories = pageResolver.pageFactories()
        for pageFactory in pageFactories {
            let page = pageFactory.createPage()
            page.register(with: registry)
            pages.append(page)
        }
        self.pages = pages
    }

    deinit {
        for page in pages {
            page.unregister(from: registry)
        }
    }
}
