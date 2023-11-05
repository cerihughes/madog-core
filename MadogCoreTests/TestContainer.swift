//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore

struct TestContainerFactory<T>: SingleContainerFactory {
    func createContainer(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> MadogUIContainer<T>? {
        TestContainer(registry: registry, tokenData: tokenData)
    }
}

extension MadogUIIdentifier where VC == ViewController, C == AnyContext<T>, TD == SingleUITokenData<T> {
    static func test() -> Self { MadogUIIdentifier("testIdentifier") }
}
