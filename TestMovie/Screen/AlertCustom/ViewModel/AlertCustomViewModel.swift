//
//  AlertCustomViewModel.swift
//  TestNews
//
//  Created by Tung Phan on 02/02/2023.
//

import UIKit

class AlertCustomViewModel: NSObject {
    
    var content: String = ""
    
    init(content: String) {
        super.init()
        self.content = content
    }

}
