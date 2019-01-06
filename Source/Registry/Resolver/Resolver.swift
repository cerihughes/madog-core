//
//  Resolver.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

/// Implementations of Resolver should return arrays of functions that can create instances of ViewControllerProvider
/// and ResourceProvider.
///
/// At the moment, the only implementation is the RuntimeResolver which uses Runtime magic to find all loaded classes
/// that implement ViewControllerProviderObject and ResourceProviderObject.
///
/// This might not be a long term solution, especially if Swift moves away from the Obj-C runtime, but it does serve as
/// a nice example of accessing the Obj-C runtime from Swift.
///
/// Other implementations can be written that (e.g.) manually instantiate the required implementations, or maybe load
/// them via a plist.

public typealias ViewControllerProviderCreationFunction = () -> ViewControllerProvider
public typealias ResourceProviderCreationFunction = (ResourceProviderCreationContext) -> ResourceProvider

public protocol Resolver {
    func viewControllerProviderCreationFunctions() -> [ViewControllerProviderCreationFunction]
    func resourceProviderCreationFunctions() -> [ResourceProviderCreationFunction]
}
