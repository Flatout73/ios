//
//  KeychainService.swift
//  Nextcloud
//
//  Created by Леонид Лядвейкин on 15/09/2018.
//  Copyright © 2018 TWS. All rights reserved.
//

import Foundation

@objc
class Credentials: NSObject {
    @objc public var login: String
    @objc public var password: String
    
    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
}

@objc
class KeychainService: NSObject {
    @objc
    class func getLoginFromKeychain() -> Credentials? {
        let queryLoad: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "hse.ru",
            kSecAttrAccessGroup as String: "group.ru.hse.Crypto-Cloud",
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        
        let resultCodeLoad = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if resultCodeLoad == noErr {
            if let dict = result as? NSDictionary,
                let pswd = String(data: dict.object(forKey: kSecValueData) as! Data, encoding: String.Encoding.utf8), let login = dict.object(forKey: kSecAttrAccount) as? String {
    
                return Credentials(login: login, password: pswd)
            }
        } else {
            print("Error loading from Keychain: \(resultCodeLoad)")
        }
        
        return nil
    }
}
