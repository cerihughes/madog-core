//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitMultiUITokenData<T>: TokenData {
    public let primaryToken: Token<T>
    public let secondaryTokens: [Token<T>]
}

public extension TokenData {
    static func splitMulti<T>(_ primaryToken: T, _ secondaryTokens: [T]) -> SplitMultiUITokenData<T> {
        .splitMulti(.use(primaryToken), secondaryTokens.map { .use($0) })
    }

    static func splitMulti<T>(_ primaryToken: Token<T>, _ secondaryTokens: [Token<T>]) -> SplitMultiUITokenData<T> {
        SplitMultiUITokenData(primaryToken: primaryToken, secondaryTokens: secondaryTokens)
    }

    static func splitMulti<T>(_ primaryToken: Token<T>, _ secondaryTokens: Token<T>...) -> SplitMultiUITokenData<T> {
        splitMulti(primaryToken, secondaryTokens)
    }
}

public typealias AnySplitMultiContainerUIFactory<T, VC> = any SplitMultiContainerUIFactory<T, VC>
public protocol SplitMultiContainerUIFactory<T, VC> where VC: ViewController {
    associatedtype T
    associatedtype VC
    func createContainer(registry: AnyRegistry<T>, tokenData: SplitMultiUITokenData<T>) -> ContainerUI<T, VC>?
}

struct ErasedSplitMultiContainerUIFactory<T> {
    private let createContainerClosure: (AnyRegistry<T>, SplitMultiUITokenData<T>) -> Any?

    init<VC, F: SplitMultiContainerUIFactory<T, VC>>(_ factory: F) {
        createContainerClosure = { factory.createContainer(registry: $0, tokenData: $1) }
    }

    func createContainer<VC>(registry: AnyRegistry<T>, tokenData: SplitMultiUITokenData<T>) -> ContainerUI<T, VC>? {
        createContainerClosure(registry, tokenData) as? ContainerUI<T, VC>
    }
}

extension SplitMultiContainerUIFactory {
    func typeErased() -> ErasedSplitMultiContainerUIFactory<T> {
        .init(self)
    }
}
