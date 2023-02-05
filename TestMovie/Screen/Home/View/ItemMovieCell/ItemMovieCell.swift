//
//  ItemMovieCell.swift
//  TestMovie
//
//  Created by Tung Phan on 29/01/2023.
//

import UIKit

protocol ItemMovieCellDelegate: AnyObject {
    func didTapFavorite(cell: UICollectionViewCell)
}

class ItemMovieCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var viewGradient: UIView!
    @IBOutlet weak var lblAverageVote: UILabel!
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var imvPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    
    // MARK: - Variables
    weak var delegate: ItemMovieCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewGradient.setGradientBackground(colorTop: UIColor.clear, colorBottom: UIColor.black.withAlphaComponent(0.65))
    }
    
    func setData(viewModel: ItemHomeMovieCellViewModel) {
        lblTitle.text = viewModel.title
        lblVoteCount.text = "\(viewModel.voteCount)"
        lblAverageVote.text = "\(viewModel.voteAverage)"
        imvPoster.loadImageWithName(name: viewModel.posterPath ?? "")
        lblReleaseDate.text = viewModel.releaseDate
        lblGenres.text = "Genres: \(viewModel.genresName ?? "")"
        let image = viewModel.isFavorite ? R.image.icHeartOrange() : R.image.icHeartWhite()
        btnFavorite.setImage(image, for: .normal)
    }
    
    func updateFavorite(isFavorite: Bool) {
        let image = isFavorite ? R.image.icHeartOrange() : R.image.icHeartWhite()
        btnFavorite.setImage(image, for: .normal)
    }
    
    @IBAction func btnFavoriteTouchUpInside(_ sender: Any) {
        delegate?.didTapFavorite(cell: self)
    }
}
