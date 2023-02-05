//
//  ItemHeaderCell.swift
//  TestMovie
//
//  Created by Tung Phan on 28/01/2023.
//

import UIKit

class ItemHeaderCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var lblTitle: UILabel!
    
    // MARK: - Variables

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(title: String) {
        lblTitle.text = title
    }

    override var isSelected: Bool {
        didSet {
            let textColor = isSelected ? R.color.appTintColor() : UIColor.white
            lblTitle.textColor = textColor
        }
    }
}
