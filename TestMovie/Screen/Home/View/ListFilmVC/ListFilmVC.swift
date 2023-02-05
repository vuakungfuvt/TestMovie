//
//  ListFilmVC.swift
//  TestMovie
//
//  Created by Tung Phan on 28/01/2023.
//

import UIKit

protocol ListFilmDelegate: AnyObject {
    func didSelectMovie(movie: Movie)
    func didTapFavorite(movie: Movie, isFavorite: Bool)
}

class ListFilmVC: UIViewController, XibViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var homeType: MovieHomeType = .nowPlaying
    private let refreshControl = UIRefreshControl()
    private var movies = [Movie]()
    private var viewModel: ListFilmViewModel!
    weak var delegate: ListFilmDelegate?
    private var isLoadingData: Bool = false
    
    // MARK: - ViewController life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupView() {
        collectionView.registerNibCellFor(type: ItemMovieCell.self)
        collectionView.registerNibCellFor(type: ItemHomeLoadMoreCell.self)
        collectionView.set(delegateAndDataSource: self)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = R.color.appTintColor()
        collectionView.refreshControl = refreshControl
        
        viewModel.reloadCollectionView = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.view.hideLoadingIndicator()
                self.collectionView.reloadData()
                self.collectionView.performBatchUpdates {
                    self.isLoadingData = false
                }
            }
        }
        
        viewModel.showErrorMessage = { [weak self] message in
            self?.showErrorMessage(errorContent: message)
        }
        
        viewModel.noticeUpdateFavorite = { [weak self] isFavorite in
            self?.showToastFavorite(isFavorite: isFavorite)
        }
        
        viewModel.reloadCell = { [weak self] indexPath, isFavorite in
            guard let self = self, let itemCell = self.collectionView.cellForItem(at: indexPath) as? ItemMovieCell else { return }
            itemCell.updateFavorite(isFavorite: isFavorite)
        }
    }
    
    func initData() {
        self.viewModel = ListFilmViewModel(homeType: homeType, service: MovieAPI())
        loadAllMovies()
    }
    
    func loadAllMovies() {
        self.view.showLoadingIndicator()
        
        self.viewModel.getListMovies() { _, _ in
        } failure: { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view.hideLoadingIndicator()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func refresh() {
        self.view.showLoadingIndicator()
        self.viewModel.refresh()
    }
    
    // MARK: - Util
    func updateFavoriteMovie(id: Int, isFavorite: Bool) {
        guard let indexPath = viewModel.getIndexPath(movieId: id),
              let itemCell = collectionView.cellForItem(at: indexPath) as? ItemMovieCell else {
            return
        }
        itemCell.updateFavorite(isFavorite: isFavorite)
    }
}

// MARK: - UICollectionViewDataSource

extension ListFilmVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getItemCells().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemType = viewModel.getItemCells()[indexPath.item]
        switch itemType {
        case .movie:
            guard let itemCell = collectionView.reusableCell(type: ItemMovieCell.self, indexPath: indexPath) else {
                return UICollectionViewCell()
            }
            let cellViewModel = viewModel.itemCellViewModel[indexPath.item]
            itemCell.setData(viewModel: cellViewModel)
            itemCell.delegate = self
            return itemCell
        case .loadMore:
            guard let itemMoreCell = collectionView.reusableCell(type: ItemHomeLoadMoreCell.self, indexPath: indexPath) else {
                return UICollectionViewCell()
            }
            itemMoreCell.rotate()
            
            if !isLoadingData {
                viewModel.loadMore()
                self.isLoadingData = true
            }
            return itemMoreCell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ListFilmVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCell = (SCREEN_WIDTH - 60) / 3
        return CGSize(width: widthCell, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = collectionView.cellForItem(at: indexPath) as? ItemMovieCell else {
            return
        }
        let movie = viewModel.getModel(indexPath: indexPath)
        delegate?.didSelectMovie(movie: movie)
    }
}

// MARK: - ItemMovieCellDelegate

extension ListFilmVC: ItemMovieCellDelegate {
    func didTapFavorite(cell: UICollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let infor = viewModel.getMovieInfor(indexPath: indexPath)
        delegate?.didTapFavorite(movie: infor.0, isFavorite: infor.1)
    }
}
