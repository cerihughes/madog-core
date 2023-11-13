//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

class ContainerProxy<T, TD, VC>: Container where TD: TokenData, VC: ViewController {
    weak var wrapped: ContainerUI<T, TD, VC>?

    init(wrapped: ContainerUI<T, TD, VC>) {
        self.wrapped = wrapped
    }

    var uuid: UUID { wrapped?.uuid ?? UUID() }
    var presentingContainer: AnyContainer<T>? { wrapped?.presentingContainer }
    var castValue: AnyContainer<T>? { wrapped }

    func close(animated: Bool, completion: CompletionBlock?) -> Bool {
        wrapped?.close(animated: animated, completion: completion) ?? false
    }

    @discardableResult
    func change<VC2, TD2>(
        to identifier: ContainerUI<T, TD2, VC2>.Identifier,
        tokenData: TD2,
        transition: Transition?,
        customisation: CustomisationBlock<VC2>?
    ) -> AnyContainer<T>? where VC2: ViewController, TD2: TokenData {
        wrapped?.change(to: identifier, tokenData: tokenData, transition: transition, customisation: customisation)
    }
}

extension ContainerUI {
    func proxy() -> AnyContainer<T> {
        ContainerProxy(wrapped: self)
    }
}
