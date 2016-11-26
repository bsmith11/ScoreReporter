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
    
    static func deleteAll() {
        let fetchRequest = NSFetchRequest<User>(entityName: entityName)
        
        do {
            let context = coreDataStack.mainContext
            let objects = try context.fetch(fetchRequest)
            
            context.perform {
                objects.forEach { context.delete($0) }
                
                if let error = context.saveToStore() {
                    print("Failed to save context: \(context) with error: \(error)")
                }
            }
        }
        catch let error {
            print("Failed to delete objects of type: \(self) with error: \(error)")
        }
    }

    static func user(from dictionary: [String: Any], completion: ((User?) -> Void)?) {
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
        return #keyPath(User.userID)
    }
}

// MARK: - CoreDataImportable

extension User: CoreDataImportable {
    public static func object(from dictionary: [String : Any], context: NSManagedObjectContext) -> User? {
        guard let userID = dictionary[APIConstants.Response.Keys.memberID] as? NSNumber,
              let accountID = dictionary[APIConstants.Response.Keys.accountID] as? NSNumber else {
            return nil
        }

        guard let user = object(primaryKey: userID, context: context, createNew: true) else {
            return nil
        }

        user.userID = userID
        user.accountID = accountID

        if !user.hasPersistentChangedValues {
            context.refresh(user, mergeChanges: false)
        }

        return user
    }
}
