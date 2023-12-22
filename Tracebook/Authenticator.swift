//
//  Authenticator.swift
//  Tracebook
//
//  Created by Marcus Painter on 08/12/2023.
//

import Foundation

protocol Authenticator {
    func authenticate(username: String, password: String) -> (isAuthenticated: Bool, message: String)
}
