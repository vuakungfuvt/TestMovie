//
//  FavoriteMovieVC.swift
//  TestMovie
//
//  Created by Tung Phan on 02/02/2023.
//

import UIKit
import IQKeyboardManager

class FavoriteMovieVC: UIViewController, XibViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private let viewModel = FavoriteMoviesViewModel()
    
    // MARK: - ViewController life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.setGradientBackground(colorTop: R.color.gradientTop()!, colorBottom: R.color.gradientBottom()!)
    }
    
    func setupView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tfSearch.attributedPlaceholder = NSAttributedString(
            string: "Search Movies",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        tfSearch.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        tableView.registerNibCellFor(type: ItemSearchMovieCell.self)
        tableView.registerNibCellFor(type: ItemNotFoundMovieCell.self)
        tableView.registerNibCellFor(type: ItemLoadMoreTableViewCell.self)
        tableView.set(delegateAndDataSource: self)
        tableView.separatorColor = UIColor.white.withAlphaComponent(0.6)
    }
    
    func initData() {
        viewModel.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    
    @objc func textFieldDidChange() {
        guard let text = tfSearch.text else {
            return
        }
    }
}

// MARK: - UITableViewDataSource

extension FavoriteMovieVC: UITableViewDataSource {
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
            return itemCell
        case .blank:
            guard let blankCell = tableView.reusableCell(type: ItemNotFoundMovieCell.self, indexPath: indexPath) else {
                return UITableViewCell()
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
}

// MARK: - UITableViewDelegate

extension FavoriteMovieVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard viewModel.getItemCells()[indexPath.row] == .movie else {
            return
        }
        let movieId = viewModel.getIdMovie(indexPath: indexPath)
        MovieDetailVC.push(from: self, animated: true) { vc in
            vc.movieId = movieId
        } completion: {
            
        }
    }
}
