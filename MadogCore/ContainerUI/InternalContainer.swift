//
//  Created by Ceri Hughes on 20/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnyInternalContainer<T> = any InternalContainer<T>

public protocol InternalContainer<T>: AnyObject, Container {
    var childContainers: [AnyContainer<T>] { get set }

    func proxy() -> AnyContainer<T>
}
