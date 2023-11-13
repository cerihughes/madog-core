//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore

extension TestContainerUI {
    struct Factory: SingleContainerUIFactory {
        func createContainer(
            registry: AnyRegistry<T>,
            tokenData: SingleUITokenData<T>
        ) -> ContainerUI<T, ViewController>? {
            TestContainerUI(registry: registry, tokenData: tokenData)
        }
    }
}

extension ContainerUI.Identifier where VC == ViewController, TD == SingleUITokenData<T> {
    static func test() -> Self { .init("testIdentifier") }
}
