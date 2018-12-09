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
    private let bundle: Bundle

    private var loadedPageFactoryTypes = [PageFactory.Type]()
    private var loadedStateFactoryTypes = [StateFactory.Type]()

    convenience public init() {
        self.init(bundle: Bundle.main)
    }

    public init(bundle: Bundle) {
        self.bundle = bundle

        inspectLoadedClasses()
    }

    // MARK: PageResolver

    public func pageFactoryTypes() -> [PageFactory.Type] {
        return loadedPageFactoryTypes
    }

    // MARK: StateResolver

    public func stateFactoryTypes() -> [StateFactory.Type] {
        return loadedStateFactoryTypes
    }

    // MARK: Private

    private func inspectLoadedClasses() {
        if let executablePath = bundle.executablePath {
            var classCount: UInt32 = 0
            let classNames = objc_copyClassNamesForImage(executablePath, &classCount)
            if let classNames = classNames {
                for i in 0 ..< classCount {
                    let className = classNames[Int(i)]
                    let name = String.init(cString: className)
                    if let cls = NSClassFromString(name) as? PageFactory.Type {
                        loadedPageFactoryTypes.append(cls)
                    }
                    if let cls = NSClassFromString(name) as? StateFactory.Type {
                        loadedStateFactoryTypes.append(cls)
                    }
                }
            }

            free(classNames);

            // Sort factories alphabetically by class name
            loadedPageFactoryTypes.sort { String(describing: $0) < String(describing: $1) }
            loadedStateFactoryTypes.sort { String(describing: $0) < String(describing: $1) }
        }
    }
}
