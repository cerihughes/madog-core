//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation
import Provident

public typealias AnyRegistry<T> = any Registry<T>

public protocol Registry<T>: AnyObject {
    associatedtype T

    func createViewController(from token: T, container: MadogUIContainer<T>) -> ViewController?
}

class RegistryBridge<T>: Registry {
    private let bridged: Provident.AnyRegistry<T, AnyContext<T>>

    init(bridged: Provident.AnyRegistry<T, AnyContext<T>>) {
        self.bridged = bridged
    }

    func createViewController(from token: T, container: MadogUIContainer<T>) -> ViewController? {
        bridged.createViewController(from: token, context: container.wrapped())
    }
}

extension Provident.Registry where C == AnyContext<T> {
    func  bridged() -> AnyRegistry<T> {
        RegistryBridge(bridged: self)
    }
}
