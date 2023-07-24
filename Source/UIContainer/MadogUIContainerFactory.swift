//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

class MadogUIContainerFactory<T> {
    private let registry: RegistryImplementation<T>
    private var singleVCUIRegistry = [String: Madog<T>.SingleUIFunction]()
    private var multiVCUIRegistry = [String: Madog<T>.MultiUIFunction]()
    private var splitSingleVCUIRegistry = [String: Madog<T>.SplitSingleUIFunction]()
    private var splitMultiVCUIRegistry = [String: Madog<T>.SplitMultiUIFunction]()

    init(registry: RegistryImplementation<T>) {
        self.registry = registry

        _ = addUIFactory(identifier: .basic(), function: BasicContainer.init(registry:token:))
        _ = addUIFactory(identifier: .navigation(), function: NavigationContainer.init(registry:token:))
        _ = addUIFactory(identifier: .tabBar(), function: TabBarContainer.init(registry:tokens:))
        _ = addUIFactory(identifier: .tabBarNavigation(), function: TabBarNavigationContainer.init(registry:tokens:))
    }

    func addUIFactory<C>(
        identifier: MadogUIIdentifier<some ViewController, C, SingleUITokenData<T>, T>,
        function: @escaping Madog<T>.SingleUIFunction
    ) -> Bool {
        guard singleVCUIRegistry[identifier.value] == nil else { return false }
        singleVCUIRegistry[identifier.value] = function
        return true
    }

    func addUIFactory<C>(
        identifier: MadogUIIdentifier<some ViewController, C, MultiUITokenData<T>, T>,
        function: @escaping Madog<T>.MultiUIFunction
    ) -> Bool {
        guard multiVCUIRegistry[identifier.value] == nil else { return false }
        multiVCUIRegistry[identifier.value] = function
        return true
    }

    func addUIFactory<C>(
        identifier: MadogUIIdentifier<some ViewController, C, SplitSingleUITokenData<T>, T>,
        function: @escaping Madog<T>.SplitSingleUIFunction
    ) -> Bool {
        guard splitSingleVCUIRegistry[identifier.value] == nil else { return false }
        splitSingleVCUIRegistry[identifier.value] = function
        return true
    }

    func addUIFactory<C>(
        identifier: MadogUIIdentifier<some ViewController, C, SplitMultiUITokenData<T>, T>,
        function: @escaping Madog<T>.SplitMultiUIFunction
    ) -> Bool {
        guard splitMultiVCUIRegistry[identifier.value] == nil else { return false }
        splitMultiVCUIRegistry[identifier.value] = function
        return true
    }

    func createUI<TD, C>(
        identifier: MadogUIIdentifier<some UIViewController, C, TD, T>,
        tokenData: TD
    ) -> MadogUIContainer<T>? where TD: TokenData {
        if let td = tokenData as? SingleUITokenData<T> {
            return singleVCUIRegistry[identifier.value]?(registry, td.token)
        }
        if let td = tokenData as? MultiUITokenData<T> {
            return multiVCUIRegistry[identifier.value]?(registry, td.tokens)
        }
        if let td = tokenData as? SplitSingleUITokenData<T> {
            return splitSingleVCUIRegistry[identifier.value]?(registry, td.primaryToken, td.secondaryToken)
        }
        if let td = tokenData as? SplitMultiUITokenData<T> {
            return splitMultiVCUIRegistry[identifier.value]?(registry, td.primaryToken, td.secondaryTokens)
        }
        return nil
    }
}
