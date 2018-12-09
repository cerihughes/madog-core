//
//  WeakContextFactory.swift
//  MadogSample
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

internal typealias WeakContextCreationFunction = (Context) -> Context?

internal class WeakContextFactory {
    private var weakContextCreationFunctions = [WeakContextCreationFunction]()

    internal init() {
        weakContextCreationFunctions.append { (context) -> Context? in
            if let context = context as? NavigationContext {
                return WeakNavigationContext(context)
            }
            return nil
        }

        weakContextCreationFunctions.append { (context) -> Context? in
            if let context = context as? TabBarNavigationContext {
                return WeakTabBarNavigationContext(context)
            }
            return nil
        }
    }

    internal func createWeakContext(for context: Context) -> Context? {
        return weakContextCreationFunctions.compactMap { $0(context) }.first
    }
}

internal class WeakNavigationContext: NavigationContext {
    private weak var target: NavigationContext?

    internal init(_ target: NavigationContext) {
        self.target = target
    }

    // MARK: - Context

    internal func change<VC: UIViewController>(to uiIdentifier: SinglePageUIIdentifier<VC>, with token: Any) -> Bool {
        return target?.change(to: uiIdentifier, with: token) ?? false
    }

    internal func change<VC: UIViewController>(to uiIdentifier: MultiPageUIIdentifier<VC>, with tokens: [Any]) -> Bool {
        return target?.change(to: uiIdentifier, with: tokens) ?? false
    }

    // MARK:- ModalContext

    internal func openModal(with token: Any, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        return target?.openModal(with: token, from: fromViewController, animated: animated)
    }

    // MARK: - ForwardBackNavigationContext

    internal func navigateForward(with token: Any, animated: Bool) -> NavigationToken? {
        return target?.navigateForward(with: token, animated: animated)
    }

    internal func navigateBack(animated: Bool) -> Bool {
        return target?.navigateBack(animated: animated) ?? false
    }
}

internal class WeakTabBarNavigationContext: TabBarNavigationContext {
    private weak var target: TabBarNavigationContext?

    internal init(_ target: TabBarNavigationContext) {
        self.target = target
    }

    // MARK: - Context

    internal func change<VC: UIViewController>(to uiIdentifier: SinglePageUIIdentifier<VC>, with token: Any) -> Bool {
        return target?.change(to: uiIdentifier, with: token) ?? false
    }

    internal func change<VC: UIViewController>(to uiIdentifier: MultiPageUIIdentifier<VC>, with tokens: [Any]) -> Bool {
        return target?.change(to: uiIdentifier, with: tokens) ?? false
    }

    // MARK: - ModalContext

    internal func openModal(with token: Any, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        return target?.openModal(with: token, from: fromViewController, animated: animated)
    }

    // MARK: - ForwardBackNavigationContext

    internal func navigateForward(with token: Any, animated: Bool) -> NavigationToken? {
        return target?.navigateForward(with: token, animated: animated)
    }

    internal func navigateBack(animated: Bool) -> Bool {
        return target?.navigateBack(animated: animated) ?? false
    }
}
