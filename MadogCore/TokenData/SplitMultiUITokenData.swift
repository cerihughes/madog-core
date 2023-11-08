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

public typealias AnySplitMultiContainerFactory<T> = any SplitMultiContainerFactory<T>
public protocol SplitMultiContainerFactory<T> {
    associatedtype T
    func createContainer(registry: AnyRegistry<T>, tokenData: SplitMultiUITokenData<T>) -> Container<T>?
}
