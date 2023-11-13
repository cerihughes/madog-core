//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

struct IdentifiableToken<T, TD, VC> where TD: TokenData, VC: ViewController {
    let identifier: ContainerUI<T, TD, VC>.Identifier
    let data: TD
}

typealias AnyContainerDelegate<T> = any ContainerDelegate<T>

protocol ContainerDelegate<T>: AnyObject {
    associatedtype T

    func createContainer<VC, TD>(
        identifiableToken: IdentifiableToken<T, TD, VC>,
        isModal: Bool,
        customisation: CustomisationBlock<VC>?
    ) -> ContainerUI<T, TD, VC>? where VC: ViewController, TD: TokenData

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

    var registry: AnyRegistry<T>?
    public let uuid = UUID()
    public let viewController: VC

    weak var delegate: AnyContainerDelegate<T>?

    public init(viewController: VC) {
        self.viewController = viewController
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
        guard let presentingViewController = viewController.presentingViewController else { return nil }
        return delegate?.container(for: presentingViewController)
    }

    public func close(animated: Bool, completion: CompletionBlock?) -> Bool {
#if canImport(UIKit)
        closeContainer(presentedViewController: viewController, animated: animated, completion: completion)
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
            let window = viewController.view.window
        else { return nil }

        window.setRootViewController(container.viewController, transition: transition)
        return container.proxy()
    }
}
