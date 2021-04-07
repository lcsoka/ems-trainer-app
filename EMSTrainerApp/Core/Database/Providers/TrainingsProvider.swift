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
    
    // MARK: - Init
    init(api: ApiService, mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext,
         backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext) {
        self.api = api
        self.mainContext = mainContext
        self.backgroundcontext = backgroundContext
    }
    
    func fetchTrainings() {
        
        mainContext.performAndWait {
            do {
                let trainings = try mainContext.fetch(Training.fetchRequest()) as! [Training]
                for training in trainings {
                    
                    print(training.trainingValues?.allObjects)
                }
            } catch let error {
                print("Failed to fetch: \(error)")
            }
        }
        
        //
        
//                api.get(MeResource(), params: nil, onSuccess: { response in
//                    if let trainings = response?.trainings {
//                        self.importTrainings(from:trainings)
//                    }
//                }, onError: { error in
//
//                })
    }
    
    
    private func importTrainings(from trainings: [TrainingJSON]) {
        for training in trainings {
            if let trainingObject = insertTraining(from: training) {
                let objectID = trainingObject.objectID
                for value in training.values {
                    insertTrainingValue(from: value, for: objectID)
                }
            }
        }
    }
    
    private func insertTraining(from json: TrainingJSON ) -> Training? {
        var training: Training?
        self.backgroundcontext.performAndWait {
            let trainingObject = Training(context: self.backgroundcontext)
            // Set up data
            trainingObject.id = Int32(json.id)
            trainingObject.length = Int32(json.length)
            trainingObject.trainingMode = json.trainingMode
            trainingObject.createdAt = json.createdAt
            
            training = trainingObject
            
            try? backgroundcontext.save()
        }
        return training
    }
    
    private func insertTrainingValue(from json: TrainingValueJSON, for objectID: NSManagedObjectID) -> TrainingValue? {
        var trainingValue: TrainingValue?
        self.backgroundcontext.performAndWait {
            let trainingValueObject = TrainingValue(context: self.backgroundcontext)
            
            trainingValueObject.timestamp = Int32(json.timestamp)
            trainingValueObject.master = Int32(json.master)
            
            if let training = backgroundcontext.object(with: objectID) as? Training {
                trainingValueObject.training = training
            }
            
            trainingValue = trainingValueObject
            try? backgroundcontext.save()
        }
        
        return trainingValue
    }
}
