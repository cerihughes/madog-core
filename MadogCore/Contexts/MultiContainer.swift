//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public protocol MultiContainer {
    var selectedIndex: Int { get nonmutating set }
}

public extension Container {
    var multi: MultiContainer? {
        castValue as? MultiContainer
    }
}
