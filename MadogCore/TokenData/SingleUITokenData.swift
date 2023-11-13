//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SingleUITokenData<T>: TokenData {
    public let token: T
}

public extension TokenData {
    static func single<T>(_ token: T) -> SingleUITokenData<T> {
        SingleUITokenData(token: token)
    }
}

public typealias AnySingleContainerUIFactory<T, VC> = any SingleContainerUIFactory<T, VC>
public protocol SingleContainerUIFactory<T, VC> where VC: ViewController {
    associatedtype T
    associatedtype VC

    typealias TD = SingleUITokenData<T>

    func createContainer(registry: AnyRegistry<T>, tokenData: TD) -> ContainerUI<T, TD, VC>?
}

struct ErasedSingleContainerUIFactory<T> {
    typealias TD = SingleUITokenData<T>

    private let createContainerClosure: (AnyRegistry<T>, TD) -> Any?

    init<VC, F>(_ factory: F) where VC: ViewController, F: SingleContainerUIFactory<T, VC> {
        createContainerClosure = { factory.createContainer(registry: $0, tokenData: $1) }
    }

    func createContainer<VC>(
        registry: AnyRegistry<T>,
        identifiableToken: IdentifiableToken<T, TD, VC>
    ) -> ContainerUI<T, TD, VC>? {
        createContainerClosure(registry, identifiableToken.data) as? ContainerUI<T, TD, VC>
    }
}

extension SingleContainerUIFactory {
    func typeErased() -> ErasedSingleContainerUIFactory<T> {
        .init(self)
    }
}
