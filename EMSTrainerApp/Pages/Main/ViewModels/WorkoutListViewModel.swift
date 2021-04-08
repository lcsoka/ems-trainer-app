//
//  WorkoutListViewModel.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 08..
//

import Foundation
import CoreData

class WorkoutListViewModel {
    
    var trainingsProvider: TrainingsProvider
    
    lazy var fetchAllWorkouts: NSFetchedResultsController<Training> = {
        // Create a fetch request for the Training entity sorted by created date.
        let fetchRequest = NSFetchRequest<Training>(entityName: "Training")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        // Create a fetched results controller and set its fetch request, context, and delegate.
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: trainingsProvider.mainContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        // Perform the fetch.
        do {
            try controller.performFetch()
        } catch {
            fatalError("Unresolved error \(error)")
        }
        
        return controller
    }()
    
    init(trainingsProvider: TrainingsProvider) {
        self.trainingsProvider = trainingsProvider
    }
    
}
