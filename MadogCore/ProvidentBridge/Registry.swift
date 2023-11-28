//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation
import Provident

public typealias AnyRegistry<T> = any Registry<T>

public protocol Registry<T>: AnyObject {
    associatedtype T

    func createViewController<VC, TD>(token: T, container: ContainerUI<T, TD, VC>) throws -> ViewController
}

public enum MadogError<T>: Error {
    case noMatchingViewController(T)
    case noMatchingContainer(String)
    case internalError(String)
    case containerReleased
    case containerHasNoWindow
    case cannotNavigateBack
}

class RegistryBridge<T>: Registry {
    private let bridged: Provident.AnyRegistry<T, AnyContainer<T>>

    init(bridged: Provident.AnyRegistry<T, AnyContainer<T>>) {
        self.bridged = bridged
    }

    func createViewController<VC, TD>(token: T, container: ContainerUI<T, TD, VC>) throws -> ViewController {
        do {
            return try bridged.createViewController(token: token, context: container.proxy())
        } catch ProvidentError<T>.noMatchingViewController(let token) {
            throw MadogError<T>.noMatchingViewController(token)
        } catch {
            throw MadogError<T>.internalError("Unexpected Provident error")
        }
    }
}

extension Provident.Registry where C == AnyContainer<T> {
    func  bridged() -> AnyRegistry<T> {
        RegistryBridge(bridged: self)
    }
}
