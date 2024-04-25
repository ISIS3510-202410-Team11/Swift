//
//  KeychainHelper.swift
//  RideShare
//
//  Created by Pablo Junco on 24/04/24.
//

import Foundation
import Security

class KeychainHelper {
    
    static let serviceIdentifier = "com.jp.junco.Moviles.RideShareV2"
    static let accountName = "MyAppAccount"


    static func storeData(email: String, password: String) {
            // Store or update email
            storeOrUpdateItem(account: "MyRideShareEmail", data: email.data(using: .utf8)!, label: "User Email")
            // Store or update password
            storeOrUpdateItem(account: "MyRideShareAccount", data: password.data(using: .utf8)!, label: "User Password")
        }

        // Helper function to store or update a Keychain item
        private static func storeOrUpdateItem(account: String, data: Data, label: String) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: account,
                kSecAttrService as String: serviceIdentifier,
                kSecAttrLabel as String: label
            ]

            let attributesToUpdate: [String: Any] = [
                kSecValueData as String: data
            ]

            // Try updating first
            let updateStatus = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if updateStatus == errSecSuccess {
                print("Updated item in Keychain")
            } else if updateStatus == errSecItemNotFound {
                // If item doesn't exist, add it
                var newQuery = query
                newQuery[kSecValueData as String] = data
                newQuery[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
                let addStatus = SecItemAdd(newQuery as CFDictionary, nil)
                if addStatus == errSecSuccess {
                    print("Added item to Keychain")
                } else {
                    print("Failed to add item to Keychain, error: \(addStatus)")
                }
            } else {
                print("Failed to update Keychain, error: \(updateStatus)")
            }
        }
    

        static func retrieveCredentials() -> (email: String?, password: String?) {

            let email = retrieveItem(account: "MyRideShareEmail")

            let password = retrieveItem(account: "MyRideShareAccount")

            return (email, password)
        }


        private static func retrieveItem(account: String) -> String? {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: account,
                kSecAttrService as String: serviceIdentifier,
                kSecReturnData as String: true,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]

            var item: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &item)

            if status == noErr, let data = item as? Data, let result = String(data: data, encoding: .utf8) {
                return result
            } else {
                print("Failed to retrieve item for account \(account): \(status)")
                return nil
            }
        }
    
    static func deleteAllCredentials() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: serviceIdentifier
        ]

        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess {
            print("Failed to delete all items from Keychain: \(status)")
        }
    }
}
