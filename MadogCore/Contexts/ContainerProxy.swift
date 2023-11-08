//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

class ContainerProxy<T>: Container {
    weak var wrapped: ContainerUI<T>?

    init(wrapped: ContainerUI<T>) {
        self.wrapped = wrapped
    }

    var uuid: UUID { wrapped?.uuid ?? UUID() }
    var presentingContainer: AnyContainer<T>? { wrapped?.presentingContainer }
    var castValue: AnyContainer<T>? { wrapped }

    func close(animated: Bool, completion: CompletionBlock?) -> Bool {
        wrapped?.close(animated: animated, completion: completion) ?? false
    }

    @discardableResult
    func change<VC, TD>(
        to identifier: ContainerUI<T>.Identifier<VC, TD>,
        tokenData: TD,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> AnyContainer<T>? where VC: ViewController, TD: TokenData {
        wrapped?.change(to: identifier, tokenData: tokenData, transition: transition, customisation: customisation)
    }
}

extension ContainerUI {
    func proxy() -> AnyContainer<T> {
        ContainerProxy(wrapped: self)
    }
}
