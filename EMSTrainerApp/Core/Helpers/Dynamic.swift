//
//  Dynamic.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 21..
//

import Foundation

class Dynamic<T> {
    
    var bind :(T) -> () = { _ in }
    
    var value :T? {
        didSet {
            bind(value!)
        }
    }
    
    init(_ v :T) {
        value = v
    }   
}
