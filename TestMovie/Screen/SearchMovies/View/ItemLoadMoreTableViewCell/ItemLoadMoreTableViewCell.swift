//
//  ItemLoadMoreTableViewCell.swift
//  TestMovie
//
//  Created by Tung Phan on 01/02/2023.
//

import UIKit

class ItemLoadMoreTableViewCell: UITableViewCell {
    @IBOutlet weak var imvReload: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutMargins = .zero
        separatorInset = .zero
    }
    
    func rotate() {
        imvReload.rotate()
    }
}
