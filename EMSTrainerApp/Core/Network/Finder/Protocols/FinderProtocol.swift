//
//  FinderProtocol.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 15..
//

import Foundation

protocol FinderProtocol {
    var delegate: FinderDelegate? { get set }
    
    func start()
    
    func stop()
}
