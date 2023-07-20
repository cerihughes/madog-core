//
//  MadogTypes.swift
//  Madog
//
//  Created by Ceri Hughes on 03/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Provident

public typealias Registry<T> = Provident.Registry<T, Context>
public typealias Registrar<T> = Provident.Registrar<T, Context>
public typealias ViewControllerProvider<T> = Provident.ViewControllerProvider<T, Context>
public typealias SingleViewControllerProvider<T> = Provident.SingleViewControllerProvider<T, Context>
public typealias Resolver<T> = Provident.Resolver<T, Context>
public typealias ServiceProvider = Provident.ServiceProvider
public typealias ServiceProviderCreationContext = Provident.ServiceProviderCreationContext
