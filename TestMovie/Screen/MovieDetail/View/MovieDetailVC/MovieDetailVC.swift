//
//  MovieDetailVC.swift
//  TestMovie
//
//  Created by Tung Phan on 29/01/2023.
//

import UIKit

protocol MovieDetailVCDelegate: AnyObject {
    func didUpdateFavoriteMovie(id: Int, isFavorite: Bool)
}

class MovieDetailVC: UIViewController, XibViewController {

    // MARK: - Outlets
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imvBackDrop: UIImageView!
    @IBOutlet weak var imvPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblTags: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblSpokenLanguage: UILabel!
    @IBOutlet weak var lblAverageVote: UILabel!
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var btnFavorite: UIButton!
    
    // MARK: - Variables
    var movieId: Int?
    private var viewModel: MovieDetailViewModel?
    weak var delegate: MovieDetailVCDelegate?
    
    // MARK: - ViewController life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.setGradientBackground(colorTop: R.color.gradientTop()!, colorBottom: R.color.gradientBottom()!)
    }
    
    func setupView() {
        viewModel?.didUpdateFavoriteMovie = { [weak self] isFavorite in
            guard let self = self else { return }
            let image = isFavorite ? R.image.icHeartOrange() : R.image.icHeartWhite()
            self.btnFavorite.setImage(image, for: .normal)
            self.showToastFavorite(isFavorite: isFavorite)
        }
        
        viewModel?.showErrorMessage = { [weak self] message in
            self?.showErrorMessage(errorContent: message)
        }
    }
    
    func initData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        self.viewModel = MovieDetailViewModel(movieId: movieId ?? 1, service: MovieAPI(), movieLocalData: MovieLocalData(context: context))
        self.view.showLoadingIndicator()
        self.viewModel?.getMovieDetail(success: { _ in
            DispatchQueue.main.async {
                self.view.hideLoadingIndicator()
                self.loadData()
            }
        }, failure: { error in
            DispatchQueue.main.async {
                self.view.hideLoadingIndicator()
            }
        })
        let isFavorite = viewModel?.getFavorite() ?? false
        let image = isFavorite ? R.image.icHeartOrange() : R.image.icHeartWhite()
        btnFavorite.setImage(image, for: .normal)
    }
    
    func loadData() {
        guard let movieDetail = self.viewModel?.movieDetail else {
            return
        }
        
        lblTitle.text = movieDetail.title
        let movieGenres = movieDetail.genres
        let genresName = movieGenres.compactMap { $0.name }.joined(separator: ", ")
        lblGenres.text = "Genres: \(genresName)"
        imvBackDrop.loadImageWithName(name: movieDetail.backdropPath)
        imvPoster.loadImageWithName(name: movieDetail.posterPath)
        lblTags.text = "Tag: \(movieDetail.tagline)"
        lblReleaseDate.text = "Release date: \(movieDetail.releaseDate)"
        if let spokenLanguages = movieDetail.spokenLanguages {
            lblSpokenLanguage.text = "Languages: \(spokenLanguages.compactMap { $0.name }.joined(separator: ", "))"
        }
        lblOverview.text = movieDetail.overview
        lblVoteCount.text = "\(movieDetail.voteCount)"
        lblAverageVote.text = "\(movieDetail.voteAverage)"
    }
    
    // MARK: - Actions
    @IBAction func btnBackTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFavoriteTouchUpInside(_ sender: Any) {
        viewModel?.setFavorite()
        guard let movieId = movieId else {
            return
        }
        delegate?.didUpdateFavoriteMovie(id: movieId, isFavorite: viewModel?.getFavorite() ?? false)
    }
}
	
