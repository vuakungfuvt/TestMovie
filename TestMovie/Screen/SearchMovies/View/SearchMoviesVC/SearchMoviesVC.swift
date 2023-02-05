//
//  SearchMoviesVC.swift
//  TestMovie
//
//  Created by Tung Phan on 31/01/2023.
//

import UIKit
import IQKeyboardManager

class SearchMoviesVC: UIViewController, XibViewController {

    // MARK: - Outlets
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private let refreshControl = UIRefreshControl()
    private var viewModel: SearchMoviesViewModel!
    private var isLoadingData: Bool = false
    
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
        tfSearch.attributedPlaceholder = NSAttributedString(
            string: "Search Movies",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        tfSearch.becomeFirstResponder()
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        tfSearch.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        tableView.registerNibCellFor(type: ItemSearchMovieCell.self)
        tableView.registerNibCellFor(type: ItemNotFoundMovieCell.self)
        tableView.registerNibCellFor(type: ItemLoadMoreTableViewCell.self)
        tableView.set(delegateAndDataSource: self)
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.6)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.tintColor = R.color.appTintColor()
        tableView.refreshControl = refreshControl
        
        self.viewModel.reloadTableView = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view.hideLoadingIndicator()
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
                self.tableView.performBatchUpdates {
                    
                } completion: { _ in
                    self.isLoadingData = false
                }
            }
        }
        
        viewModel.reloadCell = { [weak self] indexPath, isFavorite in
            guard let self = self, let itemCell = self.tableView.cellForRow(at: indexPath) as? ItemSearchMovieCell else { return }
            itemCell.updateFavorite(isFavorite: isFavorite)
        }
        
        viewModel.noticeUpdateFavorite = { [weak self] isFavorite in
            self?.showToastFavorite(isFavorite: isFavorite)
        }
        
        
        viewModel.showErrorMessage = { [weak self] message in
            self?.showErrorMessage(errorContent: message)
        }
    }
    
    func initData() {
        viewModel = SearchMoviesViewModel(service: MovieAPI())
    }
    
    @objc func search(isShowLoading: Bool = false) {
        guard let key = tfSearch.text, key.count >= 2 else {
            return
        }
        
        if isShowLoading {
            self.view.showLoadingIndicator()
        }
        self.viewModel.searchMovies(key: key) { _, _ in
            
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            self.view.hideLoadingIndicator()
        }
    }
    
    // MARK: - Actions
    
    @objc func textFieldDidChange() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(search), object: nil)
        self.perform(#selector(self.search), with: nil, afterDelay: 0.5)
    }

    @IBAction func btnBackTouchUpInside(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func refresh() {
        self.viewModel.refresh(key: tfSearch.text!)
    }
}

// MARK: - UITableViewDataSource

extension SearchMoviesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getItemCells().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.getItemCells()[indexPath.row]
        switch item {
        case .movie:
            guard let itemCell = tableView.reusableCell(type: ItemSearchMovieCell.self, indexPath: indexPath) else {
                return UITableViewCell()
            }
            let itemVM = viewModel.getItemViewModel(indexPath: indexPath)
            itemCell.setData(viewModel: itemVM)
            itemCell.delegate = self
            return itemCell
        case .blank:
            guard let blankCell = tableView.reusableCell(type: ItemNotFoundMovieCell.self, indexPath: indexPath) else {
                return UITableViewCell()
            }
            blankCell.didTapTryAgainButton = { [weak self] in
                guard let self = self else {
                    return
                }
                self.tfSearch.text = ""
                self.tfSearch.becomeFirstResponder()
            }
            return blankCell
        case .loadMore:
            guard let moreCell = tableView.reusableCell(type: ItemLoadMoreTableViewCell.self, indexPath: indexPath) else {
                return UITableViewCell()
            }
            moreCell.separatorInset = .zero
            moreCell.rotate()
            return moreCell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let _ = cell as? ItemLoadMoreTableViewCell else {
            return
        }
        if !isLoadingData {
            viewModel.loadMore(key: tfSearch.text!)
            self.isLoadingData = true
        }
    }
}

// MARK: - UITableViewDelegate

extension SearchMoviesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard viewModel.getItemCells()[indexPath.row] == .movie else {
            return
        }
        let movie = viewModel.getModel(indexPath: indexPath)
        MovieDetailVC.push(from: self, animated: true) { vc in
            vc.movieId = movie.id
            vc.delegate = self
        } completion: {
            
        }
    }
}

// MARK: - ItemSearchMovieCellDelegate

extension SearchMoviesVC: ItemSearchMovieCellDelegate {
    func didTapFavorite(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        tfSearch.resignFirstResponder()
        viewModel.updateFavoriteMovie(indexPath: indexPath)
    }
}

// MARK: - MovieDetailVCDelegate

extension SearchMoviesVC: MovieDetailVCDelegate {
    func didUpdateFavoriteMovie(id: Int, isFavorite: Bool) {
        guard let indexPath = self.viewModel.getIndexPath(movieId: id) else {
            return
        }
        guard let itemCell = self.tableView.cellForRow(at: indexPath) as? ItemSearchMovieCell else { return }
        itemCell.updateFavorite(isFavorite: isFavorite)
    }
}
