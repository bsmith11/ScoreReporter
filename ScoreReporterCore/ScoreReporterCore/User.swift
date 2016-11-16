//
//  User.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class User: NSManagedObject {
    
}

// MARK: - Public

public extension User {
    static var currentUser: User? {
        guard let userIDString = KeychainService.load(.userID),
              let userID = Int(userIDString) else {
            return nil
        }
        
        return object(primaryKey: NSNumber(value: userID), context: User.coreDataStack.mainContext)
    }
    
    static func user(from dictionary: [String: AnyObject], completion: ((User?) -> Void)?) {
        var userID: NSNumber?
        
        let block = { (context: NSManagedObjectContext) -> Void in
            userID = User.object(from: dictionary, context: context)?.userID
        }
        
        coreDataStack.performBlockUsingBackgroundContext(block) { error in
            if let userID = userID {
                let user = User.object(primaryKey: userID, context: User.coreDataStack.mainContext)
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
    public static var primaryKey: String {
        return "userID"
    }
}

// MARK: - CoreDataImportable

extension User: CoreDataImportable {
    public static func object(from dictionary: [String : AnyObject], context: NSManagedObjectContext) -> User? {
        guard let userID = dictionary["MemberId"] as? NSNumber,
              let accountID = dictionary["AccountId"] as? NSNumber else {
            return nil
        }
        
        guard let user = object(primaryKey: userID, context: context, createNew: true) else {
            return nil
        }
        
        user.userID = userID
        user.accountID = accountID
        
        return user
    }
}
