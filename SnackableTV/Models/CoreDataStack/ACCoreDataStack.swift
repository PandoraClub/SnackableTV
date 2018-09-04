//
//  ACCoreDataStack.swift
//  <?>App
//
//  Created by Austin Chen on 2016-04-28.
//

import Foundation
import CoreData

protocol ACCoreDataStackType {
    var mainManagedObjectContext: NSManagedObjectContext { get }
    var syncManagedObjectContext: NSManagedObjectContext { get }
    func destroyPersistentStore()
}

class ACCoreDataStack: NSObject, ACCoreDataStackType {
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.QoC.williamosler_patient_monitoring" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: kACCoreDataStackSqliteName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel) // to be replaced by encrypted CoreData
        let url = self.applicationDocumentsDirectory.appendingPathComponent(kACCoreDataStackSqliteFileName)
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                       configurationName: nil,
                                                       at: url,
                                                       options:[NSMigratePersistentStoresAutomaticallyOption: true,
                                                                NSInferMappingModelAutomaticallyOption: true])
        } catch let error as NSError {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        } catch let e {
            log(error: e.localizedDescription)
        }
        return coordinator
    }()
    
    lazy var syncManagedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.mergePolicy = ACMergePolicy(mode: .local)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.mergePolicy = ACMergePolicy(mode: .local)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
}

fileprivate let kACCoreDataStackSqliteName = "SnackableTV"
fileprivate let kACCoreDataStackSqliteFileName = kACCoreDataStackSqliteName + ".sqlite"


extension ACCoreDataStack {
    func destroyPersistentStore() {
        let url = self.applicationDocumentsDirectory.appendingPathComponent(kACCoreDataStackSqliteFileName)
        do {
            try self.persistentStoreCoordinator.destroyPersistentStore(at: url,
                                                                       ofType: NSSQLiteStoreType,
                                                                       options: [NSMigratePersistentStoresAutomaticallyOption: true,
                                                                                 NSInferMappingModelAutomaticallyOption: true])
        } catch let e {
            log(error: e.localizedDescription)
        }
    }
}
