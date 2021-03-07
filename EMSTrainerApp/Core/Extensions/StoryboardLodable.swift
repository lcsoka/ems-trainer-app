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
    
}

extension AuthenticationStoryboardLodable where Self: UIViewController {
    @nonobjc static var storyboardName: String {
        return "Authentication"
    }
}
