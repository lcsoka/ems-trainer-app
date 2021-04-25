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
    @IBOutlet var achievementsCollectionView: UICollectionView!
    
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
        
        achievementsCollectionView.delegate = self
        achievementsCollectionView.dataSource = self
        achievementsCollectionView.backgroundColor = .clear
        achievementsCollectionView.reloadData()
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

extension DashboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.achievementTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "achievementType", for: indexPath as IndexPath) as! AchievementCell
        
        
        
        let type = viewModel.achievementTypes[indexPath.row]
        cell.image.image = UIImage(named: type.image)
        cell.lblName.text = type.name
        
        if viewModel.hasAchievement(type: type.className) {
            cell.image.alpha = 1
        } else {
            cell.image.alpha = 0.5
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 40) / 3, height: collectionView.frame.height - 20)
        
    }
}

class AchievementCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
    @IBOutlet var lblName: UILabel!
    
}
