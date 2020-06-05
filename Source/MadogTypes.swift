//
//  MadogTypes.swift
//  Madog
//
//  Created by Ceri Hughes on 03/05/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Provident

public typealias Registry<Token> = Provident.Registry<Token, Context>
public typealias Registrar<Token> = Provident.Registrar<Token, Context>
public typealias ViewControllerProvider<Token> = Provident.ViewControllerProvider<Token, Context>
public typealias SingleViewControllerProvider<Token> = Provident.SingleViewControllerProvider<Token, Context>
public typealias Resolver<Token> = Provident.Resolver<Token, Context>
public typealias ServiceProvider = Provident.ServiceProvider
public typealias ServiceProviderCreationContext = Provident.ServiceProviderCreationContext
