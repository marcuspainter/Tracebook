//
//  KeychainWrapper.swift
//  Tracebook
//
//  Created by Marcus Painter on 08/12/2023.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

class PasswordStore {
    private(set) var service: String
    private(set) var account: String

    init(service: String, account: String) {
        self.service = service
        self.account = account
    }

    func setPassword(password: String) throws {
        guard let passwordData = password.data(using: .utf8) else {
            print("Error converting value to data.")
            throw KeychainError.unexpectedPasswordData
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: passwordData
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            break
        default:
            throw KeychainError.unhandledError(status: status)
        }
    }

    func getPassword() throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }

        guard
            let existingItem = item as? [String: Any],
            let valueData = existingItem[kSecValueData as String] as? Data,
            let value = String(data: valueData, encoding: .utf8)
        else {
            throw KeychainError.unexpectedPasswordData
        }

        return value
    }

    func updatePassword(password: String) throws {
        guard let passwordData = password.data(using: .utf8) else {
            print("Error converting value to data.")
            throw KeychainError.unexpectedPasswordData
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]

        let attributes: [String: Any] = [
            kSecValueData as String: passwordData
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    func deletePassword() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }
}
