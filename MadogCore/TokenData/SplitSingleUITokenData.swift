//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitSingleUITokenData<T>: TokenData {
    public let primaryToken: T
    public let secondaryToken: T?
}

public extension TokenData {
    static func splitSingle<T>(_ primaryToken: T, _ secondaryToken: T? = nil) -> SplitSingleUITokenData<T> {
        SplitSingleUITokenData(primaryToken: primaryToken, secondaryToken: secondaryToken)
    }
}

public typealias AnySplitSingleContainerUIFactory<T, VC> = any SplitSingleContainerUIFactory<T, VC>
public protocol SplitSingleContainerUIFactory<T, VC> where VC: ViewController {
    associatedtype T
    associatedtype VC

    typealias TD = SplitSingleUITokenData<T>

    func createContainer(registry: AnyRegistry<T>, tokenData: TD) -> ContainerUI<T, TD, VC>?
}

struct ErasedSplitSingleContainerUIFactory<T> {
    private let createContainerClosure: (AnyRegistry<T>, TD) -> Any?

    typealias TD = SplitSingleUITokenData<T>

    init<VC, F>(_ factory: F) where VC: ViewController, F: SplitSingleContainerUIFactory<T, VC> {
        createContainerClosure = { factory.createContainer(registry: $0, tokenData: $1) }
    }

    func createContainer<VC>(
        registry: AnyRegistry<T>,
        identifiableToken: IdentifiableToken<T, TD, VC>
    ) -> ContainerUI<T, TD, VC>? {
        createContainerClosure(registry, identifiableToken.data) as? ContainerUI<T, TD, VC>
    }
}

extension SplitSingleContainerUIFactory {
    func typeErased() -> ErasedSplitSingleContainerUIFactory<T> {
        .init(self)
    }
}
