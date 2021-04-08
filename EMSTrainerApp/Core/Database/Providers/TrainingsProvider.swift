//
//  TrainingsProvider.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 06..
//

import Foundation
import CoreData

public class TrainingsProvider {
    
    // MARK: - Contexts
    let backgroundcontext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    // MARK: - Init
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext,
         backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext) {
        self.mainContext = mainContext
        self.backgroundcontext = backgroundContext
    }
        
    func importTrainings(from trainings: [TrainingJSON]) {
        // Just in case order them by id
        let sortedTrainings = trainings.sorted(by:{$0.id < $1.id})
        
        // Get an array of the ids
        let trainingIds = sortedTrainings.map { $0.id }

        let fetchRequest = NSFetchRequest<Training>(entityName: "Training")
        fetchRequest.predicate = NSPredicate(format:"id IN %@", trainingIds)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        var trainingObjects: [Training] = []
        
        // Fetch existing trainings
        self.mainContext.performAndWait {
            do {
                trainingObjects = try mainContext.fetch(fetchRequest)
            } catch let error {
                print("Couldn't fetch trainings. \(error.localizedDescription)")
            }
        }
        
        self.backgroundcontext.performAndWait {
            for i in 0..<sortedTrainings.count {
                var trainingObject: Training
                
                if i <= trainingObjects.count - 1 {
                    // Existing training
                    trainingObject = backgroundcontext.object(with: trainingObjects[i].objectID) as! Training
                    let trainingValues = trainingObject.trainingValues?.allObjects as! [TrainingValue]
                    for item in trainingValues.sorted(by: {$0.timestamp < $1.timestamp}).enumerated() {
                        let trainingValue = sortedTrainings[i].values[item.offset]
                        let trainingValueObject = item.element
                        trainingValueObject.timestamp = Int32(trainingValue.timestamp)
                        trainingValueObject.master = Int32(trainingValue.master)
                    }
                } else {
                    // New training
                    trainingObject = Training(context: self.backgroundcontext)
                    // Add training values
                    for trainingValue in sortedTrainings[i].values {
                        let trainingValueObject = TrainingValue(context: self.backgroundcontext)
                        trainingValueObject.timestamp = Int32(trainingValue.timestamp)
                        trainingValueObject.master = Int32(trainingValue.master)
                        trainingValueObject.training = trainingObject
                    }
                }
                
                // Set up data
                trainingObject.id = Int32(sortedTrainings[i].id)
                trainingObject.length = Int32(sortedTrainings[i].length)
                trainingObject.trainingMode = sortedTrainings[i].trainingMode
                trainingObject.createdAt = sortedTrainings[i].createdAt
            }
            try? backgroundcontext.save()
        }
        
        // Should reset cache after successful insert
        mainContext.reset()
    }
    
    func deleteAll() {
        backgroundcontext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Training")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            
            // Execute the batch insert
            if let batchDeleteResult = try? self.backgroundcontext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
            }
        }
    }
}
