//
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//  Created by Ceri Hughes on 07/11/2023.
//

import Provident

public typealias Registry<T> = Provident.Registry<T, AnyContext<T>>
public typealias AnyRegistry<T> = any MadogCore.Registry<T>

public typealias ServiceProvider = Provident.ServiceProvider
public typealias ServiceProviderCreationContext = Provident.ServiceProviderCreationContext
