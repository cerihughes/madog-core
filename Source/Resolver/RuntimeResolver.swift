//
//  RuntimePageResolver.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

/// An implementation of PageResolver and StateResolver which uses objc-runtime magic to find all loaded classes that
/// implement Page and State respectively.
public final class RuntimeResolver: PageResolver, StateResolver {
    private var loadedPageFactories = [PageFactory.Type]()
    private var loadedStateFactories = [StateFactory.Type]()

    public init() {
        inspectLoadedClasses()
    }

    // MARK: PageResolver

    public func pageFactories() -> [PageFactory.Type] {
        return loadedPageFactories
    }

    // MARK: StateResolver

    public func stateFactories() -> [StateFactory.Type] {
        return loadedStateFactories
    }

    // MARK: Private

    private func inspectLoadedClasses() {
        if let executablePath = Bundle.main.executablePath {
            var classCount: UInt32 = 0
            let classNames = objc_copyClassNamesForImage(executablePath, &classCount)
            if let classNames = classNames {
                for i in 0 ..< classCount {
                    let className = classNames[Int(i)]
                    let name = String.init(cString: className)
                    if let cls = NSClassFromString(name) as? PageFactory.Type {
                        loadedPageFactories.append(cls)
                    }
                    if let cls = NSClassFromString(name) as? StateFactory.Type {
                        loadedStateFactories.append(cls)
                    }
                }
            }

            free(classNames);

            // Sort factories alphabetically by class name
            loadedPageFactories.sort { String(describing: $0) < String(describing: $1) }
            loadedStateFactories.sort { String(describing: $0) < String(describing: $1) }
        }
    }
}
