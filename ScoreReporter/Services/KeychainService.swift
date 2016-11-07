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
    case AccessToken
    case UserID
    
    var identifier: String {
        switch self {
        case .AccessToken:
            return "access_token"
        case .UserID:
            return "user_id"
        }
    }
}

public class KeychainService: NSObject {
    private static let userAccount = "authenticatedUser"
    
    private static let kSecClassValue = kSecClass as String
    private static let kSecAttrAccountValue = kSecAttrAccount as String
    private static let kSecValueDataValue = kSecValueData as String
    private static let kSecClassGenericPasswordValue = kSecClassGenericPassword as String
    private static let kSecAttrServiceValue = kSecAttrService as String
    private static let kSecMatchLimitValue = kSecMatchLimit as String
    private static let kSecReturnDataValue = kSecReturnData as String
    private static let kSecMatchLimitOneValue = kSecMatchLimitOne as String
}

// MARK: - Public

public extension KeychainService {
    static func save(valueType: KeychainValueType, value: String) {
        save(valueType.identifier, string: value)
    }
    
    static func load(valueType: KeychainValueType) -> String? {
        return load(valueType.identifier)
    }
    
    static func delete(valueType: KeychainValueType) {
        delete(valueType.identifier)
    }
    
    static func deleteAllStoredValues() {
        delete(.AccessToken)
        delete(.UserID)
    }
}

// MARK: - Private

private extension KeychainService {
    static func save(service: String, string: String) {
        if let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let query = [
                kSecClassValue: kSecClassGenericPasswordValue,
                kSecAttrServiceValue: service,
                kSecAttrAccountValue: userAccount,
                kSecValueDataValue: data
            ]
            
            SecItemDelete(query)
            SecItemAdd(query, nil)
        }
    }
    
    static func load(service: String) -> String? {
        let query = [
            kSecClassValue: kSecClassGenericPasswordValue,
            kSecAttrServiceValue: service,
            kSecAttrAccountValue: userAccount,
            kSecReturnDataValue: true,
            kSecMatchLimitValue: kSecMatchLimitOneValue
        ]
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(&result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        var string: String? = nil
        if status == errSecSuccess {
            if let data = result as? NSData {
                string = NSString(data: data, encoding: NSUTF8StringEncoding) as? String
            }
        }
        
        return string
    }
    
    static func delete(service: String) {
        let query = [
            kSecClassValue: kSecClassGenericPasswordValue,
            kSecAttrServiceValue: service,
            kSecAttrAccountValue: userAccount
        ]
        
        SecItemDelete(query)
    }
}
