//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public protocol MultiContext {
    var selectedIndex: Int { get set }
}

public extension Context {
    var multi: MultiContext? {
        self as? MultiContext
    }
}
