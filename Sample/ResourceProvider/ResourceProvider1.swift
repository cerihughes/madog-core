//
//  ResourceProvider1.swift
//  MadogSample
//
//  Created by Ceri Hughes on 24/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation
import Madog

let resourceProvider1Name = "resourceProvider1Name"

class ResourceProvider1: ResourceProviderObject {

    // MARK: ResourceProviderObject

    required init(context: ResourceProviderCreationContext) {
        super.init(context: context)
        name = resourceProvider1Name
    }

    let somethingShared: Any = "This is a shared resource"
}
