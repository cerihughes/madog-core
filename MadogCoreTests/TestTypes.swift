//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import XCTest

import MadogCore

class TestResolver: Resolver {
    func viewControllerProviderFunctions() -> [() -> AnyViewControllerProvider<Int>] {
        [TestViewControllerProvider.init]
    }

    func serviceProviderFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        [TestServiceProvider.init(context:)]
    }
}

class TestViewControllerProvider: ViewControllerProvider {
    func createViewController(token: Int, context: AnyContext<Int>) -> ViewController? {
        TestViewController(context: context)
    }
}

protocol TestViewControllerDelegate: AnyObject {
    func testViewControllerDidDeallocate()
}

class TestViewController<Int>: ViewController {
    let context: AnyContext<Int>

    weak var delegate: TestViewControllerDelegate?

    init(context: AnyContext<Int>) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        delegate?.testViewControllerDidDeallocate()
    }
}

class TestServiceProvider: ServiceProvider {
    var name = "TestServiceProvider"

    init(context _: ServiceProviderCreationContext) {}
}
