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
    var achievementsService: AchievementsService
    var achievementTypes: [AchievementType] = []
    var achievements: [Achievement] = []
    lazy var fetchAllWorkouts: NSFetchedResultsController<Training> = {
        // Create a fetch request for the Training entity sorted by created date.
        let fetchRequest = NSFetchRequest<Training>(entityName: "Training")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
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
    
    
    init(api: ApiService, trainingsProvider: TrainingsProvider, achievementsService: AchievementsService) {
        self.api = api
        self.trainingsProvider = trainingsProvider
        self.achievementsService = achievementsService
        
        let jsonData = Bundle.main.loadFile(filename: "AchievementTypes.json")!
        achievementTypes = try! JSONDecoder().decode([AchievementType].self, from: jsonData)
        
        if let achievements = achievementsService.achievements {
            self.achievements = achievements
        }
        
        // Fetch trainings
        self.refresh()
    }
    
    private func fetchMeData(completion: @escaping () -> Void) {
        api.get(MeResource(), params: nil, onSuccess: { response in
            if let trainings = response?.trainings {
                self.trainingsProvider.importTrainings(from:trainings)
                completion()
            }
            
            if let achievements = response?.achievements {
                self.achievementsService.achievements = achievements
                self.achievements = achievements
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
    
    func hasAchievement(type: String) -> Bool {
        return achievements.filter{$0.className == type}.count > 0
    }
}
