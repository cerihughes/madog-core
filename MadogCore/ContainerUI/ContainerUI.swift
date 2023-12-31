//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

struct IdentifiableToken<T, TD, VC> where TD: TokenData, VC: ViewController {
    let identifier: ContainerUI<T, TD, VC>.Identifier
    let data: TD
}

typealias AnyContainerUIDelegate<T> = any ContainerUIDelegate<T>

protocol ContainerUIDelegate<T>: AnyObject {
    associatedtype T

    func createContainer<TD, VC>(
        identifiableToken: IdentifiableToken<T, TD, VC>,
        parent: AnyInternalContainer<T>?,
        customisation: CustomisationBlock<VC>?
    ) throws -> ContainerUI<T, TD, VC> where VC: ViewController, TD: TokenData

    func releaseContainer(_ container: AnyContainer<T>)
}

open class ContainerUI<T, TD, VC>: InternalContainer where TD: TokenData, VC: ViewController {

    public struct Identifier {
        let value: String

        public init(_ value: String) {
            self.value = value
        }
    }

    var contentFactory: AnyContainerUIContentFactory<T>?
    public let uuid = UUID()
    public let containerViewController: VC

    weak var parentInternalContainer: AnyInternalContainer<T>?
    var childInternalContainers = [AnyInternalContainer<T>]()

    weak var delegate: AnyContainerUIDelegate<T>?

    public init(containerViewController: VC) {
        self.containerViewController = containerViewController
    }

    public func createContentViewController(token: Token<T>) throws -> ViewController {
        guard let contentFactory else { throw MadogError<T>.internalError("ContentFactory not set in \(self)") }
        return try contentFactory.createContentViewController(token: token, parent: self)
    }

    open func populateContainer(tokenData: TD) throws {
        // Override point
    }

    // MARK: - InternalContainer

    func proxy() -> AnyContainer<T> {
        ContainerProxy(wrapped: self)
    }

    func addChildContainer(_ child: AnyInternalContainer<T>) {
        childInternalContainers.append(child)
    }

    func removeChildContainer(_ child: AnyInternalContainer<T>) {
        childInternalContainers.removeAll { $0.uuid == child.uuid }
    }

    // MARK: - Container

    public var parentContainer: AnyContainer<T>? {
        parentInternalContainer.flatMap { $0.proxy() }
    }

    public var childContainers: [AnyContainer<T>] {
        childInternalContainers.map { $0.proxy() }
    }

    public func close(animated: Bool, completion: CompletionBlock?) throws {
        try childContainers.forEach { try $0.close(animated: animated) }
        parentInternalContainer?.removeChildContainer(self)
        containerViewController.dismiss(animated: animated, completion: completion)
        delegate?.releaseContainer(self)
    }

    public func change<TD2, VC2>(
        to identifier: ContainerUI<T, TD2, VC2>.Identifier,
        tokenData: TD2,
        transition: Transition?,
        customisation: CustomisationBlock<VC2>?
    ) throws -> AnyContainer<T> where VC2: ViewController, TD2: TokenData {
        guard let delegate else { throw MadogError<T>.internalError("Delegate not set in \(self)") }
        guard let window = containerViewController.view.window else { throw MadogError<T>.containerHasNoWindow }
        let container = try delegate.createContainer(
            identifiableToken: .init(identifier: identifier, data: tokenData),
            parent: parentInternalContainer,
            customisation: customisation
        )
        window.setRootViewController(container.containerViewController, transition: transition)
        return container.proxy()
    }
}
