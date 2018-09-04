//
//  NSFetchResultsControllerExtension.swift
//  <?>App
//
//  Created by Austin Chen on 2016-08-26.
//  Copyright © 2016 10.1. All rights reserved.
//

import Foundation
import CoreData

protocol ACFetchedResultsControllerProtocol {
    static func instantiate(entityName: String,
                            predicate: NSPredicate?,
                            managedObjectContext: NSManagedObjectContext?,
                            fetchOffset: Int,
                            fetchLimit: Int,
                            sortDescriptors: [NSSortDescriptor],
                            delegate: NSFetchedResultsControllerDelegate?,
                            sectionNameKeyPath: String?,
                            cacheName: String?) -> NSFetchedResultsController<NSManagedObject>?
}

extension NSFetchedResultsController: ACFetchedResultsControllerProtocol {
    static func instantiate(entityName: String,
                            predicate: NSPredicate?,
                            managedObjectContext: NSManagedObjectContext?,
                            fetchOffset: Int = 0,
                            fetchLimit: Int,
                            sortDescriptors: [NSSortDescriptor],
                            delegate: NSFetchedResultsControllerDelegate?,
                            sectionNameKeyPath: String? = nil,
                            cacheName: String? = nil) -> NSFetchedResultsController<NSManagedObject>?
    {
        guard let _ = sharedAppDelegate.appConfiguration?["syncCoordinator"] as? ACSyncCoordinator else {
            return nil
        }
        guard let moc = managedObjectContext else {
            return nil
        }
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchOffset = fetchOffset
        fetchRequest.fetchLimit = fetchLimit
        
        let frc = NSFetchedResultsController<NSManagedObject>(
            fetchRequest: fetchRequest,
            managedObjectContext: moc,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: cacheName)
        frc.delegate = delegate
        return frc
    }
}
