//
//  CoreDataStack.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 06..
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    let backgroundContext: NSManagedObjectContext
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "EMSCoreData")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        mainContext = persistentContainer.viewContext
        backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType)
    }

}
