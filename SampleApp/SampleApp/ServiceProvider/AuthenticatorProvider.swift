//
//  AuthenticatorProvider.swift
//  MadogSample
//
//  Created by Ceri Hughes on 24/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation
import Madog

let authenticatorProviderName = "authenticatorProviderName"

class AuthenticatorProvider: ServiceProvider {
    let authenticator = Authenticator()

    // MARK: ServiceProviderObject

    override init(context: ServiceProviderCreationContext) {
        super.init(context: context)
        name = authenticatorProviderName
    }
}

class Authenticator {
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(true)
        }
    }

    func logout(completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(true)
        }
    }
}
