//
//  DashboardViewModel.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 04. 05..
//

import Foundation

final class DashboardViewModel {
    var api: ApiService!
    var trainingsProvider: TrainingsProvider
    init(api: ApiService) {
        self.api = api
        trainingsProvider = TrainingsProvider(api: api)
        print("model ready")
    }
    
    func test() {
        trainingsProvider.fetchTrainings()
    }
}
