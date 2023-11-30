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
    var parentContainer: AnyContainer<T>? { wrapped?.parentContainer }
    var childContainers: [AnyContainer<T>] { wrapped?.childContainers ?? [] }
    var castValue: AnyContainer<T>? { wrapped }

    func close(animated: Bool, completion: CompletionBlock?) throws {
        guard let wrapped else { throw MadogError<T>.containerReleased }
        try wrapped.close(animated: animated, completion: completion)
    }

    @discardableResult
    func change<TD2, VC2>(
        to identifier: ContainerUI<T, TD2, VC2>.Identifier,
        tokenData: TD2,
        transition: Transition?,
        customisation: CustomisationBlock<VC2>?
    ) throws -> AnyContainer<T> where VC2: ViewController, TD2: TokenData {
        guard let wrapped else { throw MadogError<T>.containerReleased }
        return try wrapped.change(
            to: identifier,
            tokenData: tokenData,
            transition: transition,
            customisation: customisation
        )
    }
}
