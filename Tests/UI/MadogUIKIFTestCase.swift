//
//  MadogUIKIFTestCase.swift
//  MadogTests
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF

@testable import Madog

class MadogUIKIFTestCase: KIFTestCase {
    class KIFTestResolver: Resolver<String> {
        override func viewControllerProviderFunctions() -> [() -> ViewControllerProvider<String>] {
            [KIFTestViewControllerProvider.init]
        }
    }

    class KIFTestViewControllerProvider: BaseViewControllerProvider {
        override func createViewController(token: String, context: Context) -> UIViewController? {
            let viewController = UIViewController()
            viewController.title = token
            return viewController
        }
    }

    func assert(token: String) {
        assert(tokens: [token])
    }

    func assert(tokens: [String]) {
        tokens.forEach {
            viewTester().usingLabel($0)?.waitForView()
        }
    }
}

#endif
