//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public typealias AnyModalToken<C> = any ModalToken<C>

public protocol ModalToken<C> {
    associatedtype C

    var context: C { get }
}

class ModalTokenImplementation<C>: ModalToken {
    let viewController: ViewController
    let context: C

    init(viewController: ViewController, context: C) {
        self.viewController = viewController
        self.context = context
    }
}
