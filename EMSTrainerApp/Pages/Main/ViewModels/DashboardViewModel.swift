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
    
    
    init(api: ApiService, trainingsProvider: TrainingsProvider) {
        self.api = api
        self.trainingsProvider = trainingsProvider
        
        // Fetch trainings
        self.refresh()
    }
    
    private func fetchMeData(completion: @escaping () -> Void) {
        api.get(MeResource(), params: nil, onSuccess: { response in
            if let trainings = response?.trainings {
                self.trainingsProvider.importTrainings(from:trainings)
                completion()
            }
        }, onError: { error in
            
        })
    }
    
    func refresh() {
        fetchMeData() {
            do {
                try self.fetchAllWorkouts.performFetch()
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
}
