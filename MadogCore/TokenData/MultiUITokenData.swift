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
    func createContainer(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) -> ContainerUI<T, VC>?
}

struct ErasedMultiContainerUIFactory<T> {
    private let createContainerClosure: (AnyRegistry<T>, MultiUITokenData<T>) -> Any?

    init<VC, F: MultiContainerUIFactory<T, VC>>(_ factory: F) {
        createContainerClosure = { factory.createContainer(registry: $0, tokenData: $1) }
    }

    func createContainer<VC>(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) -> ContainerUI<T, VC>? {
        createContainerClosure(registry, tokenData) as? ContainerUI<T, VC>
    }
}

extension MultiContainerUIFactory {
    func typeErased() -> ErasedMultiContainerUIFactory<T> {
        .init(self)
    }
}
