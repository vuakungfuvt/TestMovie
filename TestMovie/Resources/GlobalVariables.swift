//
//  GlobalVariables.swift
//  TestMovie
//
//  Created by Tung Phan on 29/01/2023.
//

import UIKit

class GlobalVariables: NSObject {
    static let shared = GlobalVariables()
    
    var movieCategories = [MovieCategory]()
    var favoriteMovies: [String: Bool] = [:]
    
    override init() {
        super.init()
        
    }
}
