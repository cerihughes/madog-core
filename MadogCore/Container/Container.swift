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
    var parentContainer: AnyContainer<T>? { get }
    var childContainers: [AnyContainer<T>] { get }
    var castValue: AnyContainer<T>? { get }

    func close(animated: Bool, completion: CompletionBlock?) throws

    @discardableResult
    func change<TD2, VC2>(
        to identifier: ContainerUI<T, TD2, VC2>.Identifier,
        tokenData: TD2,
        transition: Transition?,
        customisation: CustomisationBlock<VC2>?
    ) throws -> AnyContainer<T> where VC2: ViewController, TD2: TokenData
}

public extension Container {
    func close(animated: Bool) throws {
        try close(animated: animated, completion: nil)
    }

    @discardableResult
    func change<TD2, VC2>(
        to identifier: ContainerUI<T, TD2, VC2>.Identifier,
        tokenData: TD2,
        transition: Transition? = nil,
        customisation: CustomisationBlock<VC2>? = nil
    ) throws -> AnyContainer<T> where VC2: ViewController, TD2: TokenData {
        try change(to: identifier, tokenData: tokenData, transition: transition, customisation: customisation)
    }
}

public extension Container {
    var castValue: AnyContainer<T>? {
        self
    }
}
