//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

/// A class that presents view controllers, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
class TestNavigationContainer<T>: MadogNavigatingModalUIContainer<T> {
    private let navigationController = UINavigationController()

    init?(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) {
        super.init(registry: registry, viewController: navigationController)

        guard let viewController = registry.createViewController(from: tokenData.token, container: self) else {
            return nil
        }
        navigationController.setViewControllers([viewController], animated: false)
    }

    override func provideNavigationController() -> UINavigationController? {
        navigationController
    }
}

struct TestNavigationContainerFactory<T>: SingleContainerFactory {
    func createContainer(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> MadogUIContainer<T>? {
        TestNavigationContainer(registry: registry, tokenData: tokenData)
    }
}

extension MadogUIIdentifier where VC == UINavigationController, TD == SingleUITokenData<T> {
    static func testNavigation() -> Self { MadogUIIdentifier("testNavigationIdentifier") }
}
