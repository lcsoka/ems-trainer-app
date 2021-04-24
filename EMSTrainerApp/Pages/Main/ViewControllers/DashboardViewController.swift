//
//  DashboardViewController.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import UIKit
import CoreData

protocol DashboardViewControllerDelegate: class {
    func userDidRequestAccountPage()
    func userDidRequestWorkoutListPage()
    func userDidRequestWorkoutSetupPage()
    func userDidRequestWorkoutDetailsPage(workout: Training)
}

class DashboardViewController: UIViewController, MainStoryboardLodable {
    
    var initial = true
    
    weak var authDelegate: AuthenticationDelegate?
    
    weak var delegate: DashboardViewControllerDelegate?
    
    var viewModel: DashboardViewModel!
    
    @IBOutlet var statisticsView: StatisticsView!
    @IBOutlet var workoutListView: WorkoutsList!
    @IBOutlet var btnShowWorkoutList: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        
        workoutListView.delegate = self
        viewModel.fetchAllWorkouts.delegate = self
        
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !initial {
            viewModel.refresh()
        }
        
        initial = false
    }
    
    func setupUI() {
        title = "Dashboard"
        self.extendedLayoutIncludesOpaqueBars = true
        let statBtn = UIBarButtonItem(title: "Account", style: .plain, target: self, action: #selector(self.showAccount))
        navigationItem.rightBarButtonItems = [statBtn]
    }
    
    @objc func showAccount() {
        self.delegate?.userDidRequestAccountPage()
    }

    @IBAction func onWorkoutSetupTap(_ sender: Any) {
        self.delegate?.userDidRequestWorkoutSetupPage()
    }
    
    @IBAction func onShowMoreWorkoutTap(_ sender: Any) {
        self.delegate?.userDidRequestWorkoutListPage()
    }
    
    private func setUpViews() {
        if let workouts = viewModel.fetchAllWorkouts.fetchedObjects {
            workoutListView.items = Array(workouts.prefix(3))
            statisticsView.workouts = workouts
            
            if workouts.count > 0 {
                btnShowWorkoutList.isHidden = false
            } else {
                btnShowWorkoutList.isHidden = true
            }
        }
    }
    
}

extension DashboardViewController: WorkoutListDelegate {
    func onItemsChanged() {
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func onItemSelected(workout: Training) {
        delegate?.userDidRequestWorkoutDetailsPage(workout: workout)
    }
}

extension DashboardViewController: NSFetchedResultsControllerDelegate { 
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        setUpViews()
    }
}
