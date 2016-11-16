//
//  KeychainService.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import Security

//
// http://matthewpalmer.net/blog/2014/06/21/example-ios-keychain-swift-save-query/
//

public enum KeychainValueType {
    case accessToken
    case userID
    
    var identifier: String {
        switch self {
        case .accessToken:
            return "access_token"
        case .userID:
            return "user_id"
        }
    }
}

public class KeychainService: NSObject {
    fileprivate static let userAccount = "authenticatedUser"
    
    fileprivate static let kSecClassValue = kSecClass as String
    fileprivate static let kSecAttrAccountValue = kSecAttrAccount as String
    fileprivate static let kSecValueDataValue = kSecValueData as String
    fileprivate static let kSecClassGenericPasswordValue = kSecClassGenericPassword as String
    fileprivate static let kSecAttrServiceValue = kSecAttrService as String
    fileprivate static let kSecMatchLimitValue = kSecMatchLimit as String
    fileprivate static let kSecReturnDataValue = kSecReturnData as String
    fileprivate static let kSecMatchLimitOneValue = kSecMatchLimitOne as String
}

// MARK: - Public

public extension KeychainService {
    static func save(_ valueType: KeychainValueType, value: String) {
        save(valueType.identifier, string: value)
    }
    
    static func load(_ valueType: KeychainValueType) -> String? {
        return load(valueType.identifier)
    }
    
    static func delete(_ valueType: KeychainValueType) {
        delete(valueType.identifier)
    }
    
    static func deleteAllStoredValues() {
        delete(.accessToken)
        delete(.userID)
    }
}

// MARK: - Private

private extension KeychainService {
    static func save(_ service: String, string: String) {
        if let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            let query = [
                kSecClassValue: kSecClassGenericPasswordValue,
                kSecAttrServiceValue: service,
                kSecAttrAccountValue: userAccount,
                kSecValueDataValue: data
            ] as [String : Any]
            
            SecItemDelete(query as CFDictionary)
            SecItemAdd(query as CFDictionary, nil)
        }
    }
    
    static func load(_ service: String) -> String? {
        let query = [
            kSecClassValue: kSecClassGenericPasswordValue,
            kSecAttrServiceValue: service,
            kSecAttrAccountValue: userAccount,
            kSecReturnDataValue: true,
            kSecMatchLimitValue: kSecMatchLimitOneValue
        ] as [String : Any]
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        
        var string: String? = nil
        if status == errSecSuccess {
            if let data = result as? Data {
                string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String
            }
        }
        
        return string
    }
    
    static func delete(_ service: String) {
        let query = [
            kSecClassValue: kSecClassGenericPasswordValue,
            kSecAttrServiceValue: service,
            kSecAttrAccountValue: userAccount
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
