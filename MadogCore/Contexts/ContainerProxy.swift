//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

class ContainerProxy<T, VC>: Container where VC: ViewController {
    weak var wrapped: ContainerUI<T, VC>?

    init(wrapped: ContainerUI<T, VC>) {
        self.wrapped = wrapped
    }

    var uuid: UUID { wrapped?.uuid ?? UUID() }
    var castValue: AnyContainer<T>? { wrapped }

    func close(animated: Bool, completion: CompletionBlock?) -> Bool {
        wrapped?.close(animated: animated, completion: completion) ?? false
    }

    @discardableResult
    func change<VC2, TD>(
        to identifier: ContainerUI<T, VC2>.Identifier<TD>,
        tokenData: TD,
        transition: Transition?,
        customisation: CustomisationBlock<VC2>?
    ) -> AnyContainer<T>? where VC2: ViewController, TD: TokenData {
        wrapped?.change(to: identifier, tokenData: tokenData, transition: transition, customisation: customisation)
    }
}

extension ContainerUI {
    func proxy() -> AnyContainer<T> {
        ContainerProxy(wrapped: self)
    }
}
