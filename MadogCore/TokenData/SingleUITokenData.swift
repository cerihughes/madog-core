//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SingleUITokenData<T>: TokenData {
    public let token: Token<T>
}

public extension TokenData {
    static func single<T>(_ token: T) -> SingleUITokenData<T> {
        .single(.use(token))
    }

    static func single<T>(_ token: Token<T>) -> SingleUITokenData<T> {
        SingleUITokenData(token: token)
    }
}

public typealias AnySingleContainerUIFactory<T, VC> = any SingleContainerUIFactory<T, VC>
public protocol SingleContainerUIFactory<T, VC> where VC: ViewController {
    associatedtype T
    associatedtype VC
    func createContainer(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> ContainerUI<T, VC>?
}

struct ErasedSingleContainerUIFactory<T> {
    private let createContainerClosure: (AnyRegistry<T>, SingleUITokenData<T>) -> Any?

    init<VC, F: SingleContainerUIFactory<T, VC>>(_ factory: F) where VC: ViewController {
        createContainerClosure = { factory.createContainer(registry: $0, tokenData: $1) }
    }

    func createContainer<VC>(registry: AnyRegistry<T>, tokenData: SingleUITokenData<T>) -> ContainerUI<T, VC>? {
        createContainerClosure(registry, tokenData) as? ContainerUI<T, VC>
    }
}

extension SingleContainerUIFactory {
    func typeErased() -> ErasedSingleContainerUIFactory<T> {
        .init(self)
    }
}
