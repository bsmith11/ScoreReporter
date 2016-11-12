//
//  User.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    
}

// MARK: - Public

extension User {
    static var currentUser: User? {
        guard let userIDString = KeychainService.load(.userID),
                  let userID = Int(userIDString) else {
            return nil
        }
        
        return objectWithPrimaryKey(NSNumber(value: userID), context: User.coreDataStack.mainContext)
    }
    
    static func userFromDictionary(_ dictionary: [String: AnyObject], completion: ((User?) -> Void)?) {
        var userID: NSNumber?
        
        let block = { (context: NSManagedObjectContext) -> Void in
            userID = User.objectFromDictionary(dictionary, context: context)?.userID
        }
        
        coreDataStack.performBlockUsingBackgroundContext(block) { error in
            if let userID = userID {
                let user = User.objectWithPrimaryKey(userID, context: User.coreDataStack.mainContext)
                completion?(user)
            }
            else {
                completion?(nil)
            }
        }
    }
}

// MARK: - Fetchable

extension User: Fetchable {
    static var primaryKey: String {
        return "userID"
    }
}

// MARK: - CoreDataImportable

extension User: CoreDataImportable {
    static func objectFromDictionary(_ dictionary: [String : AnyObject], context: NSManagedObjectContext) -> User? {
        guard let userID = dictionary["MemberId"] as? NSNumber,
              let accountID = dictionary["AccountId"] as? NSNumber else {
            return nil
        }
        
        guard let user = objectWithPrimaryKey(userID, context: context, createNew: true) else {
            return nil
        }
        
        user.userID = userID
        user.accountID = accountID
        
        return user
    }
}
