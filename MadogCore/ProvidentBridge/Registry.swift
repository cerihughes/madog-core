//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation
import Provident

public typealias AnyRegistry<T> = any Registry<T>

public protocol Registry<T>: AnyObject {
    associatedtype T

    func createViewController(token: T, parent: AnyContainer<T>) throws -> ViewController
}

public enum MadogError: Error {
    case internalError
    case containerReleased
    case containerHasNoWindow
    case cannotNavigateBack
}

class RegistryBridge<T>: Registry {
    private let bridged: Provident.AnyRegistry<T, AnyContainer<T>>

    init(bridged: Provident.AnyRegistry<T, AnyContainer<T>>) {
        self.bridged = bridged
    }

    func createViewController(token: T, parent: AnyContainer<T>) throws -> ViewController {
        guard let parent = parent as? AnyInternalContainer<T> else { throw MadogError.internalError }
        return try bridged.createViewController(token: token, context: parent.proxy())
    }
}

extension Provident.Registry where C == AnyContainer<T> {
    func  bridged() -> AnyRegistry<T> {
        RegistryBridge(bridged: self)
    }
}
