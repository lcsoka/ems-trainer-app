//
//  WorkoutListViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 08..
//

import UIKit
import CoreData

protocol WorkoutListViewControllerDelegate {
    func userDidRequestWorkoutDetailsPage(workout: Training)
}

class WorkoutListViewController: UITableViewController, MainStoryboardLodable {
    
    var viewModel: WorkoutListViewModel!

    var delegate: WorkoutListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        viewModel.fetchAllWorkouts.delegate = self
        
    }
    
    func setupUI() {
        title = "Workouts"
        self.extendedLayoutIncludesOpaqueBars = true
    }
    
}

class WorkoutCell: UITableViewCell {
    @IBOutlet var workoutItem: WorkoutListItem!
    
    var workout: Training! {
        didSet {
            workoutItem.workout = workout
        }
    }
    
}

// MARK: - UITableViewDataSource
extension WorkoutListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as? WorkoutCell else {
            print("Error: tableView.dequeueReusableCell doesn'return a WorkoutCell!")
            return WorkoutCell()
        }
        guard let workout = viewModel.fetchAllWorkouts.fetchedObjects?[indexPath.row] else { return cell }
        
        cell.workout = workout
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let workout = viewModel.fetchAllWorkouts.fetchedObjects?[indexPath.row] {
            delegate?.userDidRequestWorkoutDetailsPage(workout: workout)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchAllWorkouts.fetchedObjects?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension WorkoutListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
