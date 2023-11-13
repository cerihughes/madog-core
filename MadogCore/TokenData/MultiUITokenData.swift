//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct MultiUITokenData<T>: TokenData {
    public let tokens: [T]
}

public extension TokenData {
    static func multi<T>(_ tokens: [T]) -> MultiUITokenData<T> {
        MultiUITokenData(tokens: tokens)
    }

    static func multi<T>(_ tokens: T...) -> MultiUITokenData<T> {
        multi(tokens)
    }
}

public typealias AnyMultiContainerUIFactory<T, VC> = any MultiContainerUIFactory<T, VC>
public protocol MultiContainerUIFactory<T, VC> where VC: ViewController {
    associatedtype T
    associatedtype VC

    typealias TD = MultiUITokenData<T>

    func createContainer(registry: AnyRegistry<T>, tokenData: TD) -> ContainerUI<T, TD, VC>?
}

struct ErasedMultiContainerUIFactory<T> {
    typealias TD = MultiUITokenData<T>

    private let createContainerClosure: (AnyRegistry<T>, TD) -> Any?

    init<VC, F>(_ factory: F) where VC: ViewController, F: MultiContainerUIFactory<T, VC> {
        createContainerClosure = { factory.createContainer(registry: $0, tokenData: $1) }
    }

    func createContainer<VC>(
        registry: AnyRegistry<T>,
        identifiableToken: IdentifiableToken<T, TD, VC>
    ) -> ContainerUI<T, TD, VC>? {
        createContainerClosure(registry, identifiableToken.data) as? ContainerUI<T, TD, VC>
    }
}

extension MultiContainerUIFactory {
    func typeErased() -> ErasedMultiContainerUIFactory<T> {
        .init(self)
    }
}
