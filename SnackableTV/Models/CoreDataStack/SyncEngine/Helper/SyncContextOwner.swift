//
//  SyncContextOwner.swift
//  Moody
//
//  Created by Daniel Eggert on 15/08/2015.
//  Copyright © 2015 objc.io. All rights reserved.
//

import CoreData


/// Implements the integration with Core Data change notifications.
///
/// This protocol merges changes from the main context into the sync context and vice versa.
/// It calls its `processChangedLocalObjects()` methods when objects have changed.
protocol ContextOwnerType: class, ObserverTokenStore {
    /// This is the UI / main thread managed object context
    var coreDataStack: ACCoreDataStackType { get }
    
    /// This group tracks any outstanding work.
    var syncGroup: DispatchGroup { get }
    
    var didSetup: Bool { get }
    
    /// This will be called whenever objects on the sync managed object context have changed.
    func processChangedLocalObjects(_ managedObjects: [NSManagedObject])
}


extension ContextOwnerType {
    func setupContexts() {
        setupContextNotificationObserving()
    }
    
    fileprivate func setupContextNotificationObserving() {
        addObserverToken(
            coreDataStack.mainManagedObjectContext.addContextDidSaveNotificationObserver {
                [weak self] note in
                self?.mainContextDidSave(note)
            }
        )
        addObserverToken(
            coreDataStack.syncManagedObjectContext.addContextDidSaveNotificationObserver {
                [weak self] note in
                self?.syncContextDidSave(note)
            }
        )
        addObserverToken(coreDataStack.syncManagedObjectContext.addObjectsDidChangeNotificationObserver { [weak self] note in
            self?.objectsInSyncContextDidChange(note)
        })
    }
    
    /// Merge changes from main -> sync context
    fileprivate func mainContextDidSave(_ note: ContextDidSaveNotification) {
        precondition(didSetup, "Did not call setup()")
        coreDataStack.syncManagedObjectContext
            .performMergeChangesFromContextDidSaveNotification(note)
        notifyAboutChangedObjectsFromSaveNotification(note)
    }
    
    /// Merge changes from sync -> main context
    fileprivate func syncContextDidSave(_ note: ContextDidSaveNotification) {
        precondition(didSetup, "Did not call setup()")
        coreDataStack.mainManagedObjectContext
            .performMergeChangesFromContextDidSaveNotification(note)
        notifyAboutChangedObjectsFromSaveNotification(note)
    }
    
    fileprivate func objectsInSyncContextDidChange(_ note: ObjectsDidChangeNotification) {
        precondition(didSetup, "Did not call setup()")
    }
    
    fileprivate func notifyAboutChangedObjectsFromSaveNotification(
        _ note: ContextDidSaveNotification)
    {
        precondition(didSetup, "Did not call setup()")
        
        coreDataStack.syncManagedObjectContext.performBlockWithGroup(syncGroup) {
            // We unpack the notification here, to make sure it's retained 
            // until this point.
            let updates = note.updatedObjects
                .remapToContext(self.coreDataStack.syncManagedObjectContext)
            let inserts = note.insertedObjects
                .remapToContext(self.coreDataStack.syncManagedObjectContext)
            self.processChangedLocalObjects(updates + inserts)
        }
    }
}
