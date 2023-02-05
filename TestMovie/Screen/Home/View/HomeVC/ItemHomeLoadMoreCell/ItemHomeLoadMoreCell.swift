//
//  ItemHomeLoadMoreCell.swift
//  TestMovie
//
//  Created by Tung Phan on 02/02/2023.
//

import UIKit

class ItemHomeLoadMoreCell: UICollectionViewCell {

    @IBOutlet weak var imvLoading: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func rotate() {
        imvLoading.rotate()
    }

}
