//
//  TestResolver.swift
//  MadogTests
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation
import Madog

class TestResolver: Resolver {
    private let testViewControllerProviderCreationFunctions: [ViewControllerProviderCreationFunction]
    private let testServiceProviderCreationFunctions: [ServiceProviderCreationFunction]

    init(testViewControllerProviderCreationFunctions: [ViewControllerProviderCreationFunction],
         testServiceProviderCreationFunctions: [ServiceProviderCreationFunction]) {
        self.testViewControllerProviderCreationFunctions = testViewControllerProviderCreationFunctions
        self.testServiceProviderCreationFunctions = testServiceProviderCreationFunctions

        super.init()
    }

    override func viewControllerProviderCreationFunctions() -> [ViewControllerProviderCreationFunction] {
        return testViewControllerProviderCreationFunctions
    }

    override func serviceProviderCreationFunctions() -> [ServiceProviderCreationFunction] {
        return testServiceProviderCreationFunctions
    }
}
