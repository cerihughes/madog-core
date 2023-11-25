//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

struct IdentifiableToken<T, TD, VC> where TD: TokenData, VC: ViewController {
    let identifier: ContainerUI<T, TD, VC>.Identifier
    let data: TD
}

open class ContainerUI<T, TD, VC>: InternalContainer where TD: TokenData, VC: ViewController {

    public struct Identifier {
        let value: String

        public init(_ value: String) {
            self.value = value
        }
    }

    public let uuid = UUID()
    public let containerViewController: VC

    weak var parentInternalContainer: AnyInternalContainer<T>?
    public var parentContainer: AnyContainer<T>? { parentInternalContainer }
    public var childContainers = [AnyContainer<T>]()

    var contentFactory: AnyContainerUIContentFactory<T>?

    weak var delegate: AnyContainerUIDelegate<T>?

    public init(containerViewController: VC) {
        self.containerViewController = containerViewController
    }

    public func createContentViewController(from token: Token<T>) -> ViewController? {
        contentFactory?.createContentViewController(from: token, parent: self)
    }

    open func populateContainer(tokenData: TD) {
        // Override point
    }

    // MARK: - InternalContainer

    func proxy() -> AnyContainer<T> {
        ContainerProxy(wrapped: self)
    }

    // MARK: - Container

    public func close(animated: Bool, completion: CompletionBlock?) -> Bool {
        childContainers.forEach { $0.close(animated: animated) }
        parentInternalContainer?.childContainers.removeAll(where: {
            $0.uuid == uuid
        })
        containerViewController.dismiss(animated: animated, completion: completion)
        delegate?.releaseContainer(self)
        return true
    }

    public func change<VC2, TD2>(
        to identifier: ContainerUI<T, TD2, VC2>.Identifier,
        tokenData: TD2,
        transition: Transition?,
        customisation: CustomisationBlock<VC2>?
    ) -> AnyContainer<T>? where VC2: ViewController, TD2: TokenData {
        guard
            let container = delegate?.createContainer(
                identifiableToken: .init(identifier: identifier, data: tokenData),
                parent: parentInternalContainer,
                customisation: customisation
            ),
            let window = containerViewController.view.window
        else { return nil }

        window.setRootViewController(container.containerViewController, transition: transition)
        return container.proxy()
    }
}
