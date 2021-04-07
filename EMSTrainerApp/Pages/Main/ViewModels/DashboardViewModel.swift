//
//  DashboardViewModel.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 05..
//

import Foundation
import CoreData

final class DashboardViewModel {
    var api: ApiService!
    var trainingsProvider: TrainingsProvider
    
    weak var fetchedLastThreeWorkoutsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    lazy var fetchedLastThreeWorkoutsController: NSFetchedResultsController<Training> = {
        // Create a fetch request for the Training entity sorted by created date.
        let fetchRequest = NSFetchRequest<Training>(entityName: "Training")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.fetchLimit = 3
        
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
    
    
    init(api: ApiService) {
        self.api = api
        trainingsProvider = TrainingsProvider(api: api)
        
        // Fetch trainings
        trainingsProvider.fetchTrainings()
    }
    
    func refresh() {
        trainingsProvider.fetchTrainings()
        
        do {
            try fetchedLastThreeWorkoutsController.performFetch()
        } catch {
            fatalError("Unresolved error \(error)")
        }
    }
    
}
