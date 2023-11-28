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

    func createContainer<VC, TD>(
        identifiableToken: IdentifiableToken<T, TD, VC>,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) throws -> ContainerUI<T, TD, VC> where VC: ViewController, TD: TokenData

    func container(for viewController: ViewController) -> AnyContainer<T>?
    func releaseContainer(for viewController: ViewController)
}

open class ContainerUI<T, TD, VC>: Container where TD: TokenData, VC: ViewController {

    public struct Identifier {
        let value: String

        public init(_ value: String) {
            self.value = value
        }
    }

    var contentFactory: AnyContainerUIContentFactory<T>?
    public let uuid = UUID()
    public let containerViewController: VC

    weak var delegate: AnyContainerUIDelegate<T>?

    public init(containerViewController: VC) {
        self.containerViewController = containerViewController
    }

    public func createContentViewController(token: T) throws -> ViewController {
        guard let contentFactory else { throw MadogError<T>.internalError("ContentFactory not set in \(self)") }
        return try contentFactory.createContentViewController(token: token, container: self)
    }

    open func populateContainer(tokenData: TD) throws {
        // Override point
    }

    // MARK: - Container

    public var presentingContainer: AnyContainer<T>? {
        guard let presentingViewController = containerViewController.presentingViewController else { return nil }
        return delegate?.container(for: presentingViewController)
    }

    public func close(animated: Bool, completion: CompletionBlock?) throws {
#if canImport(UIKit)
        try closeContainer(presentedViewController: containerViewController, animated: animated, completion: completion)
#endif
    }

    public func change<VC2, TD2>(
        to identifier: ContainerUI<T, TD2, VC2>.Identifier,
        tokenData: TD2,
        transition: Transition?,
        customisation: CustomisationBlock<VC2>?
    ) throws -> AnyContainer<T> where VC2: ViewController, TD2: TokenData {
        guard let delegate else { throw MadogError<T>.internalError("Delegate not set in \(self)") }
        guard let window = containerViewController.view.window else { throw MadogError<T>.containerHasNoWindow }
        let container = try delegate.createContainer(
            identifiableToken: .init(identifier: identifier, data: tokenData),
            isModal: false,
            customisation: customisation
        )
        window.setRootViewController(container.containerViewController, transition: transition)
        return container.proxy()
    }
}
