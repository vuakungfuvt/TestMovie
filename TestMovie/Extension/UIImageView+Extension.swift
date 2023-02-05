//
//  UIImageView+Extension.swift
//  TestMovie
//
//  Created by Tung Phan on 29/01/2023.
//

import UIKit
import SDWebImage 

extension UIImageView {
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
    
    func loadImageWithName(name: String) {
        let urlString = "\(baseImageUrl)\(name)"
        guard let url = URL(string: urlString) else {
            return
        }
        self.sd_setImage(with: url, placeholderImage: R.image.icMovieDefault())
    }
}
