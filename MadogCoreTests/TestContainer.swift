//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore

struct TestContainerFactory<T>: SingleContainerFactory {
    func createContainer(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> ContainerUI<T>? {
        TestContainer(registry: registry, tokenData: tokenData)
    }
}

extension ContainerUI.Identifier where VC == ViewController, TD == SingleUITokenData<T> {
    static func test() -> Self { .init("testIdentifier") }
}
