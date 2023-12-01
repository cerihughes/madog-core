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

public extension SingleUITokenData {
    func wrapping<VC>(
        identifier: ContainerUI<T, SingleUITokenData<T>, VC>.Identifier,
        customisation: CustomisationBlock<VC>? = nil
    ) -> Self where VC: ViewController {
        .init(token: identifier.wrapping(token: token, customisation: customisation))
    }
}

extension ContainerUI.Identifier where TD == SingleUITokenData<T> {
    func wrapping(
        token: Token<T>,
        customisation: CustomisationBlock<VC>? = nil
    ) -> Token<T> where VC: ViewController {
        .create(identifier: self, tokenData: .single(token), customisation: customisation)
    }
}
