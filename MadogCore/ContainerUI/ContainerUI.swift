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

protocol ContainerUIDelegate<T>: ContainerCreationDelegate {
    associatedtype T

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

    public let uuid = UUID()
    public let containerViewController: VC

    weak var delegate: AnyContainerUIDelegate<T>?

    public init(containerViewController: VC) {
        self.containerViewController = containerViewController
    }

    public func createContentViewController(
        contentFactory: AnyContainerUIContentFactory<T>,
        from token: Token<T>
    ) throws -> ViewController {
        // TODO: Remove force unwrap
        contentFactory.createContentViewController(from: token, container: self)!
    }

    open func populateContainer(contentFactory: AnyContainerUIContentFactory<T>, tokenData: TD) throws {
        // Override point
    }

    // MARK: - Container

    public var presentingContainer: AnyContainer<T>? {
        guard let presentingViewController = containerViewController.presentingViewController else { return nil }
        return delegate?.container(for: presentingViewController)
    }

    public func close(animated: Bool, completion: CompletionBlock?) -> Bool {
#if canImport(UIKit)
        closeContainer(presentedViewController: containerViewController, animated: animated, completion: completion)
#endif
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
                isModal: false,
                customisation: customisation
            ),
            let window = containerViewController.view.window
        else { return nil }

        window.setRootViewController(container.containerViewController, transition: transition)
        return container.proxy()
    }
}
