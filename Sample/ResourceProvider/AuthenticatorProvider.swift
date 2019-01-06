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

class AuthenticatorProvider: ResourceProviderObject {
    let authenticator = Authenticator()

    // MARK: ResourceProviderObject

    required init(context: ResourceProviderCreationContext) {
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
