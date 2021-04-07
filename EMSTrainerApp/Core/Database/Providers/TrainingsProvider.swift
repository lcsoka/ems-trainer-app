//
//  TrainingsProvider.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 06..
//

import Foundation
import CoreData

public class TrainingsProvider {
    
    // MARK: - Api
    private let api: ApiService
    
    // MARK: - Contexts
    let backgroundcontext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    // MARK: - NSFetchedResultsController
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    // MARK: - Init
    init(api: ApiService, mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext,
         backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext) {
        self.api = api
        self.mainContext = mainContext
        self.backgroundcontext = backgroundContext
    }
    
    func fetchTrainings() {
//
//        mainContext.performAndWait {
//            do {
//                let trainings = try mainContext.fetch(Training.fetchRequest()) as! [Training]
//                for training in trainings {
//
//                    print(training.trainingValues?.allObjects)
//                }
//            } catch let error {
//                print("Failed to fetch: \(error)")
//            }
//        }
        
        //
        
        api.get(MeResource(), params: nil, onSuccess: { response in
            if let trainings = response?.trainings {
                // Just in case order them by id
                self.importTrainings(from:trainings.sorted(by:{$0.id < $1.id}))
            }
        }, onError: { error in
            
        })
    }
    
    
    private func importTrainings(from trainings: [TrainingJSON]) {
        let trainingIds = trainings.map { $0.id }

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
            for i in 0..<trainings.count {
                var trainingObject: Training
                
                if i <= trainingObjects.count - 1 {
                    // Existing training
                    trainingObject = backgroundcontext.object(with: trainingObjects[i].objectID) as! Training
                    let trainingValues = trainingObject.trainingValues?.allObjects as! [TrainingValue]
                    for item in trainingValues.sorted(by: {$0.timestamp < $1.timestamp}).enumerated() {
                        let trainingValue = trainings[i].values[item.offset]
                        let trainingValueObject = item.element
                        trainingValueObject.timestamp = Int32(trainingValue.timestamp)
                        trainingValueObject.master = Int32(trainingValue.master)
                    }
                } else {
                    // New training
                    trainingObject = Training(context: self.backgroundcontext)
                    // Add training values
                    for trainingValue in trainings[i].values {
                        let trainingValueObject = TrainingValue(context: self.backgroundcontext)
                        trainingValueObject.timestamp = Int32(trainingValue.timestamp)
                        trainingValueObject.master = Int32(trainingValue.master)
                        trainingValueObject.training = trainingObject
                    }
                }
                
                // Set up data
                trainingObject.id = Int32(trainings[i].id)
                trainingObject.length = Int32(trainings[i].length)
                trainingObject.trainingMode = trainings[i].trainingMode
                trainingObject.createdAt = trainings[i].createdAt
            }
            try? backgroundcontext.save()
        }
    }
    
}
