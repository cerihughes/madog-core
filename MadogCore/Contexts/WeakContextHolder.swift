//
//  Created by Ceri Hughes on 08/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import Foundation

class WeakContextHolder<T>: Context {
    weak var wrapped: Container<T>?

    init(wrapped: Container<T>) {
        self.wrapped = wrapped
    }

    var presentingContext: AnyContext<T>? { wrapped?.presentingContext }

    func close(animated: Bool, completion: CompletionBlock?) -> Bool {
        wrapped?.close(animated: animated, completion: completion) ?? false
    }

    @discardableResult
    func change<VC, TD>(
        to identifier: Container<T>.Identifier<VC, TD>,
        tokenData: TD,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> AnyContext<T>? where VC: ViewController, TD: TokenData {
        wrapped?.change(to: identifier, tokenData: tokenData, transition: transition, customisation: customisation)
    }

    var castValue: AnyContext<T>? {
        wrapped
    }
}

extension Container {
    func wrapped() -> AnyContext<T> {
        WeakContextHolder(wrapped: self)
    }
}
