//
//  Created by Ceri Hughes on 07/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

import Foundation

public struct SplitMultiUITokenData<T>: TokenData {
    public let primaryToken: T
    public let secondaryTokens: [T]
}

public extension TokenData {
    static func splitMulti<T>(_ primaryToken: T, _ secondaryTokens: [T]) -> SplitMultiUITokenData<T> {
        SplitMultiUITokenData(primaryToken: primaryToken, secondaryTokens: secondaryTokens)
    }
}

public typealias AnySplitMultiContainerUIFactory<T, VC> = any SplitMultiContainerUIFactory<T, VC>
public protocol SplitMultiContainerUIFactory<T, VC> where VC: ViewController {
    associatedtype T
    associatedtype VC

    typealias TD = SplitMultiUITokenData<T>

    func createContainer(registry: AnyRegistry<T>, tokenData: TD) -> ContainerUI<T, TD, VC>?
}

extension SplitMultiContainerUIFactory {
    func wrapped() -> SplitMultiContainerUIFactoryWrapper<T> {
        .init(createContainer(registry:tokenData:))
    }
}
