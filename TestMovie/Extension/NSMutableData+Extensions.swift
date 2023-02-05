//
//  NSMutableData+Extensions.swift
//  TestMovie
//
//  Created by Tung Phan on 29/01/2023.
//

import Foundation

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
