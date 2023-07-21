//
//  ServiceProvider1.swift
//  MadogSample
//
//  Created by Ceri Hughes on 24/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation
import Madog

let serviceProvider1Name = "serviceProvider1Name"

class ServiceProvider1: ServiceProvider {
    var name = serviceProvider1Name

    init(context: ServiceProviderCreationContext) {}

    let somethingShared: Any = "This is pretending to be a shared service"
}
