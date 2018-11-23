//
//  ResourceLocator.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

/// An example of a "token" that can be used to uniquely identify a view controller.
struct ResourceLocator {
    let identifier: String
    let data: [String:Any]
}
