//
//  ItemSearchMovieCell.swift
//  TestMovie
//
//  Created by Tung Phan on 31/01/2023.
//

import UIKit

protocol ItemSearchMovieCellDelegate: AnyObject {
    func didTapFavorite(cell: UITableViewCell)
}

class ItemSearchMovieCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var lblAverageVote: UILabel!
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var imvPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var imvFavorite: UIImageView!
    @IBOutlet weak var btnFavorite: UIButton!
    
    // MARK: - Variables
    
    weak var delegate: ItemSearchMovieCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(viewModel: ItemFavoriteMoviesViewModel) {
        lblTitle.text = viewModel.title
        lblVoteCount.text = viewModel.voteCount
        lblAverageVote.text = viewModel.averageVote
        imvPoster.loadImageWithName(name: viewModel.posterPath ?? "")
        lblReleaseDate.text = viewModel.releasedDate
        lblGenres.text = "Genres: \(viewModel.genresName ?? "")"
        let image = viewModel.isFavorite ? R.image.icHeartOrange() : R.image.icHeartWhite()
        btnFavorite.setImage(image, for: .normal)
    }
    
    func setData(viewModel: ItemSearchMovieViewModel) {
        lblTitle.text = viewModel.title
        lblVoteCount.text = viewModel.voteCount
        lblAverageVote.text = viewModel.averageVote
        imvPoster.loadImageWithName(name: viewModel.posterPath ?? "")
        lblReleaseDate.text = viewModel.releasedDate
        lblGenres.text = "Genres: \(viewModel.genresName ?? "")"
        let favoriteImage = viewModel.isFavorite ? R.image.icHeartOrange() : R.image.icHeartWhite()
        btnFavorite.setImage(favoriteImage, for: .normal)
    }
    
    func updateFavorite(isFavorite: Bool) {
        let image = isFavorite ? R.image.icHeartOrange() : R.image.icHeartWhite()
        btnFavorite.setImage(image, for: .normal)
    }

    // MARK: - Action
    
    @IBAction func btnFavoriteTouchUpInside(_ sender: Any) {
        delegate?.didTapFavorite(cell: self)
    }
}
