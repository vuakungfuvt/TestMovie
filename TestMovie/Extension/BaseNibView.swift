//
//  BaseNibView.swift
//  TestMovie
//
//  Created by Tung Phan on 29/01/2023.
//

import UIKit

class BaseNibView: UIView {
    var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    private func nibSetup() {
        contentView = loadViewFromNib()
        contentView.backgroundColor = self.backgroundColor
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(contentView)
        contentView.backgroundColor = .clear
        setupViews()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    func setupViews()
    {
        
    }
}
