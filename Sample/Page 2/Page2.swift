//
//  Page2.swift
//  MadogSample
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

private let page2Identifier = "page2Identifier"

class Page2: PageFactory, Page {

    private var uuid: UUID?

    // MARK: PageFactory

    static func createPage() -> Page {
        return Page2()
    }

    // MARK: Page

    func register<Token, Context>(with registry: ViewControllerRegistry<Token, Context>) {
        uuid = registry.add(registryFunction: createViewController(token:context:))
    }

    func unregister<Token, Context>(from registry: ViewControllerRegistry<Token, Context>) {
        guard let uuid = uuid else {
            return
        }

        registry.removeRegistryFunction(uuid: uuid)
    }

    // MARK: Private

    private func createViewController<Token, Context>(token: Token, context: Context) -> UIViewController? {
        guard let rl = token as? ResourceLocator,
            rl.identifier == page2Identifier,
            let pageIdentifier = rl.pageIdentifier,
            let navigationContext = context as? NavigationContext else {
            return nil
        }

        let viewController = Page2ViewController(pageIdentifier:pageIdentifier, context: navigationContext)
        return viewController
    }
}

extension ResourceLocator {
    private static let pageIdentifierKey = "pageIdentifier"

    static func createPage2ResourceLocator(pageIdentifier: String) -> ResourceLocator {
        return ResourceLocator(identifier: page2Identifier, data: [pageIdentifierKey : pageIdentifier])
    }

    var pageIdentifier: String? {
        return data[ResourceLocator.pageIdentifierKey] as? String
    }
}
