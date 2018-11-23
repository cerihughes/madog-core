//
//  RuntimePageResolver.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

/// An implementation of PageResolver which uses objc-runtime magic to find all loaded classes that implement Page.
public final class RuntimePageResolver: PageResolver {

    public init() {}

    // MARK: PageResolver

    public func pageFactories() -> [PageFactory.Type] {
        var pageFactories = [PageFactory.Type]()

        if let executablePath = Bundle.main.executablePath {
            var classCount: UInt32 = 0
            let classNames = objc_copyClassNamesForImage(executablePath, &classCount)
            if let classNames = classNames {
                for i in 0 ..< classCount {
                    let className = classNames[Int(i)]
                    let name = String.init(cString: className)
                    if let cls = NSClassFromString(name) as? PageFactory.Type {
                        pageFactories.append(cls)
                    }
                }
            }

            free(classNames);
        }

        return pageFactories
    }
}
