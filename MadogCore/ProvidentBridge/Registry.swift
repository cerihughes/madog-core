//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation
import Provident

public typealias AnyRegistry<T> = any Registry<T>

public protocol Registry<T>: AnyObject {
    associatedtype T

    func createViewController(from token: T, parent: AnyContainer<T>) -> ViewController?
}

class RegistryBridge<T>: Registry {
    private let bridged: Provident.AnyRegistry<T, AnyContainer<T>>

    init(bridged: Provident.AnyRegistry<T, AnyContainer<T>>) {
        self.bridged = bridged
    }

    func createViewController(from token: T, parent: AnyContainer<T>) -> ViewController? {
        guard let parent = parent as? AnyInternalContainer<T> else { return nil }
        return bridged.createViewController(from: token, context: parent.proxy())
    }
}

extension Provident.Registry where C == AnyContainer<T> {
    func  bridged() -> AnyRegistry<T> {
        RegistryBridge(bridged: self)
    }
}
