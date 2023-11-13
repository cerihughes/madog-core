//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitSingleUITokenData<T>: TokenData {
    public let primaryToken: Token<T>
    public let secondaryToken: Token<T>?
}

public extension TokenData {
    static func splitSingle<T>(_ primaryToken: T, _ secondaryToken: T? = nil) -> SplitSingleUITokenData<T> {
        .splitSingle(.use(primaryToken), secondaryToken.flatMap { .use($0) })
    }

    static func splitSingle<T>(
        _ primaryToken: Token<T>,
        _ secondaryToken: Token<T>? = nil
    ) -> SplitSingleUITokenData<T> {
        SplitSingleUITokenData(primaryToken: primaryToken, secondaryToken: secondaryToken)
    }
}

public typealias AnySplitSingleContainerUIFactory<T, VC> = any SplitSingleContainerUIFactory<T, VC>
public protocol SplitSingleContainerUIFactory<T, VC> where VC: ViewController {
    associatedtype T
    associatedtype VC
    func createContainer(registry: AnyRegistry<T>, tokenData: SplitSingleUITokenData<T>) -> ContainerUI<T, VC>?
}

struct ErasedSplitSingleContainerUIFactory<T> {
    private let createContainerClosure: (AnyRegistry<T>, SplitSingleUITokenData<T>) -> Any?

    init<VC, F: SplitSingleContainerUIFactory<T, VC>>(_ factory: F) where VC: ViewController {
        createContainerClosure = { factory.createContainer(registry: $0, tokenData: $1) }
    }

    func createContainer<VC>(registry: AnyRegistry<T>, tokenData: SplitSingleUITokenData<T>) -> ContainerUI<T, VC>? {
        createContainerClosure(registry, tokenData) as? ContainerUI<T, VC>
    }
}

extension SplitSingleContainerUIFactory {
    func typeErased() -> ErasedSplitSingleContainerUIFactory<T> {
        .init(self)
    }
}
