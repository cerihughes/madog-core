//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if DEBUG

import MadogCore

extension TestContainerUI {
    struct Factory: ContainerUIFactory {
        func createContainer() -> ContainerUI<T, SingleUITokenData<T>, ViewController> {
            TestContainerUI(containerViewController: .init())
        }
    }
}

public extension ContainerUI.Identifier where VC == ViewController, TD == SingleUITokenData<T> {
    static func test() -> Self { .init("testIdentifier") }
}

#endif
