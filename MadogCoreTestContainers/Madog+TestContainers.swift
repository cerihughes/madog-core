//
//  Created by Ceri Hughes on 24/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

#if DEBUG

import MadogCore

public extension Madog {
    func registerTestContainers() {
        _ = addContainerUIFactory(identifier: .test(), factory: TestContainerUI.Factory())
#if canImport(UIKit)
        _ = addContainerUIFactory(identifier: .testNavigation(), factory: TestNavigatingContainerUI.Factory())
        _ = addContainerUIFactory(identifier: .testTabBar(), factory: TestTabBarContainerUI.Factory())
#endif
    }
}

#endif
