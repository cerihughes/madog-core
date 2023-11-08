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

public typealias AnyMultiContainerUIFactory<T> = any MultiContainerUIFactory<T>
public protocol MultiContainerUIFactory<T> {
    associatedtype T
    func createContainer(registry: AnyRegistry<T>, tokenData: MultiUITokenData<T>) -> ContainerUI<T>?
}
