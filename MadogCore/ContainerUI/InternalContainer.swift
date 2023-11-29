//
//  Created by Ceri Hughes on 20/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

typealias AnyInternalContainer<T> = any InternalContainer<T>

protocol InternalContainer<T>: AnyObject, Container {
    var childContainers: [AnyContainer<T>] { get set }

    func proxy() -> AnyContainer<T>
}
