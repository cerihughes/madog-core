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

    typealias TD = SingleUITokenData<T>

    func createContainer(registry: AnyRegistry<T>, tokenData: TD) -> ContainerUI<T, TD, VC>?
}

extension SingleContainerUIFactory {
    func wrapped() -> SingleContainerUIFactoryWrapper<T> {
        .init(createContainer(registry:tokenData:))
    }
}
