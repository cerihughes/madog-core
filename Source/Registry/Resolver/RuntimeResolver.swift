//
//  RuntimeResolver.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

/// An implementation of Resolver which uses objc-runtime magic to find all loaded classes that
/// implement PageFactory and StateFactory respectively.
public final class RuntimeResolver: Resolver {
    private let bundle: Bundle

    private var loadedPageCreationFunctions = [PageCreationFunction]()
    private var loadedStateCreationFunctions = [StateCreationFunction]()

    convenience public init() {
        self.init(bundle: Bundle.main)
    }

    public init(bundle: Bundle) {
        self.bundle = bundle

        inspectLoadedClasses()
    }

    // MARK: Resolver

    public func pageCreationFunctions() -> [PageCreationFunction] {
        return loadedPageCreationFunctions
    }

    public func stateCreationFunctions() -> [StateCreationFunction] {
        return loadedStateCreationFunctions
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
                    if let cls = NSClassFromString(name) as? PageObject.Type {
                        loadedPageCreationFunctions.append { return cls.init() }
                    }
                    if let cls = NSClassFromString(name) as? StateObject.Type {
                        loadedStateCreationFunctions.append { stateCreationContext in
                            return cls.init(stateCreationContext: stateCreationContext)
                        }
                    }
                }
            }

            free(classNames);

            // Sort functions alphabetically by description
            loadedPageCreationFunctions.sort { String(describing: $0) < String(describing: $1) }
            loadedStateCreationFunctions.sort { String(describing: $0) < String(describing: $1) }
        }
    }
}

open class PageObject: Page {
    public required init() {}
    open func register(with registry: ViewControllerRegistry) {}
    open func unregister(from registry: ViewControllerRegistry) {}
    open func configure(with state: [String:State]) {}
}

open class StateObject: State {
    public var name: String = "Default"
    public required init(stateCreationContext: StateCreationContext) {}
}
