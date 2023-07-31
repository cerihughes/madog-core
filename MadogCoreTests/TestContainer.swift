//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class TestContainer<T>: MadogModalUIContainer<T> {
    private let containerController = UIViewController()

    init?(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) {
        super.init(registry: registry, viewController: containerController)

        guard let vc = registry.createViewController(from: tokenData.token, context: self) else { return nil }

        vc.willMove(toParent: containerController)

        containerController.addChild(vc)
        containerController.view.addSubview(vc.view)
        vc.view.frame = containerController.view.bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        vc.didMove(toParent: containerController)
    }
}

struct TestContainerFactory<T>: SingleContainerFactory {
    func createContainer(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> MadogUIContainer<T>? {
        TestContainer(registry: registry, tokenData: tokenData)
    }
}

extension MadogUIIdentifier where VC == UIViewController, C == AnyModalContext<T>, TD == SingleUITokenData<T> {
    static func test() -> Self { MadogUIIdentifier("testIdentifier") }
}
