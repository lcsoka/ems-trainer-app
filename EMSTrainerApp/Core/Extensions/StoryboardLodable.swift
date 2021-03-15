//
//  StoryboardLodable.swift
//  EMSTrainerApp
//
//  Created by Laszlo Csoka on 2021. 03. 07..
//

import Foundation
import UIKit

protocol StoryboardLodable {
    @nonobjc static var storyboardName: String { get }
}

protocol AuthenticationStoryboardLodable: StoryboardLodable {
    var authDelegate: AuthenticationDelegate? { get set }
}


protocol MainStoryboardLodable: StoryboardLodable {
    
}

extension AuthenticationStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "Authentication"
    }
}

extension MainStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "Main"
    }
}
