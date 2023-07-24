//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class TestContainer<T>: MadogModalUIContainer<T> {
    private let containerController = UIViewController()

    init?(registry: AnyRegistry<T>, token: T) {
        super.init(registry: registry, viewController: containerController)

        guard let viewController = registry.createViewController(from: token, context: self) else { return nil }

        viewController.willMove(toParent: containerController)

        containerController.addChild(viewController)
        containerController.view.addSubview(viewController.view)
        viewController.view.frame = containerController.view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewController.didMove(toParent: containerController)
    }
}

extension MadogUIIdentifier where VC == UIViewController, C == AnyModalContext<T>, TD == SingleUITokenData<T> {
    static func test() -> Self { MadogUIIdentifier("testIdentifier") }
}
