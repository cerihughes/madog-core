//
//  Created by Ceri Hughes on 24/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation
import MadogCore

let authenticatorProviderName = "authenticatorProviderName"

class AuthenticatorProvider: ServiceProvider {
    let authenticator = Authenticator()

    // MARK: - ServiceProvider
    var name = authenticatorProviderName

    init(context: ServiceProviderCreationContext) {}
}

class Authenticator {
    func login(username _: String, password _: String, completion: @escaping (Bool) -> Void) {
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
