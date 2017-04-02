//
//  ManagedUser.swift
//  ScoreReporter
//
//  Created by Bradley Smith on 11/6/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation
import CoreData

public class ManagedUser: NSManagedObject {

}

// MARK: - Public

public extension ManagedUser {
    static var currentUser: ManagedUser? {
        guard let userIDString = Keychain.load(.userID),
              let userID = Int(userIDString) else {
            return nil
        }

        return object(primaryKey: NSNumber(value: userID), context: ManagedUser.coreDataStack.mainContext)
    }
    
    static func deleteAll() {
        let fetchRequest = NSFetchRequest<ManagedUser>(entityName: entityName)
        
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

    static func user(from dictionary: [String: Any], completion: ((ManagedUser?) -> Void)?) {
        var userID: NSNumber?

        let block = { (context: NSManagedObjectContext) -> Void in
            userID = ManagedUser.object(from: dictionary, context: context)?.userID
        }

        coreDataStack.performBlockUsingBackgroundContext(block) { _ in
            if let userID = userID {
                let user = ManagedUser.object(primaryKey: userID, context: ManagedUser.coreDataStack.mainContext)
                completion?(user)
            }
            else {
                completion?(nil)
            }
        }
    }
}

// MARK: - Fetchable

extension ManagedUser: Fetchable {
    public static var primaryKey: String {
        return #keyPath(ManagedUser.userID)
    }
}

// MARK: - CoreDataImportable

extension ManagedUser: CoreDataImportable {
    public static func object(from dictionary: [String: Any], context: NSManagedObjectContext) -> ManagedUser? {
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
