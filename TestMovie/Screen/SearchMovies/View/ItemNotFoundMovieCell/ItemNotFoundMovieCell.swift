//
//  ItemNotFoundMovieCell.swift
//  TestMovie
//
//  Created by Tung Phan on 31/01/2023.
//

import UIKit

class ItemNotFoundMovieCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var btnTryAgain: UIButton!
    
    // MARK: - Variables
    var didTapTryAgainButton: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Actions
    
    @IBAction func btnTryAgainTouchUpInside(_ sender: Any) {
        self.didTapTryAgainButton?()
    }
}
