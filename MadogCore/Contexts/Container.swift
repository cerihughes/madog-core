//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

public struct Transition {
    public let duration: TimeInterval
    public let options: AnimationOptions

    public init(duration: TimeInterval, options: AnimationOptions) {
        self.duration = duration
        self.options = options
    }
}

public typealias CompletionBlock = () -> Void
public typealias CustomisationBlock<VC> = (VC) -> Void where VC: ViewController
public typealias AnyContainer<T> = any Container<T>

public protocol Container<T> {
    associatedtype T

    var uuid: UUID { get }
    var presentingContainer: AnyContainer<T>? { get }
    var castValue: AnyContainer<T>? { get }

    @discardableResult
    func close(animated: Bool, completion: CompletionBlock?) -> Bool

    @discardableResult
    func change<VC, TD>(
        to identifier: ContainerUI<T>.Identifier<VC, TD>,
        tokenData: TD,
        transition: Transition?,
        customisation: CustomisationBlock<VC>?
    ) -> AnyContainer<T>? where VC: ViewController, TD: TokenData
}

public extension Container {
    @discardableResult
    func close(animated: Bool) -> Bool {
        close(animated: animated, completion: nil)
    }

    @discardableResult
    func change<VC, TD>(
        to identifier: ContainerUI<T>.Identifier<VC, TD>,
        tokenData: TD,
        transition: Transition? = nil,
        customisation: CustomisationBlock<VC>? = nil
    ) -> AnyContainer<T>? where VC: ViewController, TD: TokenData {
        change(to: identifier, tokenData: tokenData, transition: transition, customisation: customisation)
    }
}

public extension Container {
    var castValue: AnyContainer<T>? {
        self
    }
}