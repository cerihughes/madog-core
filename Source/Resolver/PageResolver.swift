//
//  PageResolver.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

/// Implementations of PageResolver should return an array of all PageFactory implementations so that they
/// can create a Page and registered it with the registry.
///
/// At the moment, the only implementation is the RuntimePageResolver which uses Runtime magic to find all loaded classes
/// that implement PageFactory. This is used to create a Page.
///
/// This might not be a long term solution, especially if Swift moves away from the Obj-C runtime, but it does serve as
/// a nice example of accessing the Obj-C runtime from Swift.
///
/// Other implementations can be written that (e.g.) manually instantiate the required implementations, or maybe load
/// them via a plist.
public protocol PageResolver {
    func pageFactories() -> [PageFactory.Type]
}
