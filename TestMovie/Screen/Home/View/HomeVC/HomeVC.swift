//
//  HomeVC.swift
//  TestMovie
//
//  Created by Tung Phan on 28/01/2023.
//

import UIKit

class HomeVC: UIViewController, XibViewController {

    // MARK: - Outlets
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indicatorLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    let homeTypes: [MovieHomeType] = [.nowPlaying, .popular, .topRated, .upComing]
    var widthCells: [CGFloat] = []
    var pageViewController: CustomPageVC?
    private var viewModel: HomeViewModel!
    fileprivate var viewControllers = [ListFilmVC]()

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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // setup collectionView
        collectionView.registerNibCellFor(type: ItemHeaderCell.self)
        collectionView.set(delegateAndDataSource: self)
        collectionView.reloadData()
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.performBatchUpdates(nil) { _ in
            self.updateIndicator(indexPath: indexPath)
        }
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
        setupPageView()
    }
    
    private func setupPageView() {
        let nowPlayingVC = ListFilmVC.create()
        nowPlayingVC.homeType = .nowPlaying
        nowPlayingVC.delegate = self
        let popularVC = ListFilmVC.create()
        popularVC.homeType = .popular
        popularVC.delegate = self
        let topRatedVC = ListFilmVC.create()
        topRatedVC.homeType = .topRated
        topRatedVC.delegate = self
        let upcomingVC = ListFilmVC.create()
        upcomingVC.homeType = .upComing
        upcomingVC.delegate = self
        viewControllers = [nowPlayingVC, popularVC, topRatedVC, upcomingVC]
        let pageViewController = CustomPageVC.initPage(viewControllers: viewControllers)
        self.pageViewController = pageViewController
        addChild(pageViewController)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(pageViewController.view)
        // constrain it to all 4 sides
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 0.0),
            pageViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
            pageViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0),
            pageViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0)
        ])
        pageViewController.view.backgroundColor = .clear
        pageViewController.didMove(toParent: self)
        pageViewController.delegate = self
    }
    
    func initData() {
        self.viewModel = HomeViewModel(service: MovieAPI(), movieLocalData: MovieLocalData())
        self.widthCells = homeTypes.compactMap {
            $0.name.width(withConstrainedHeight: 40, font: UIFont.bold(size: 16)) + 20
        }
        
        viewModel.getAllCategoriesFilm { allCategories in
            GlobalVariables.shared.movieCategories = allCategories
            print("\(GlobalVariables.shared.movieCategories)")
        } failure: { error in
            self.showError(errorContent: error.localizedDescription)
        }
        
        viewModel.showErrorMessage = { [weak self] message in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.showErrorMessage(errorContent: message)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    @IBAction func btnSearchTouchUpInside(_ sender: Any) {
        SearchMoviesVC.push(from: self, animated: true) { vc in
            
        } completion: {
            
        }

    }
    
    // MARK: - Util
    
    func updateIndicator(indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let cell = self.collectionView.cellForItem(at: indexPath)
            let frame = self.collectionView.convert(cell!.frame, to: self.collectionView.superview)
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.4) {
                self.indicatorLeadingConstraint.constant = frame.origin.x
                self.indicatorWidthConstraint.constant = self.widthCells[indexPath.item]
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension HomeVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.reusableCell(type: ItemHeaderCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        let title = homeTypes[indexPath.item].name
        cell.setData(title: title)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension HomeVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthCells[indexPath.item], height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageViewController?.scroll(index: indexPath.item)
        self.updateIndicator(indexPath: indexPath)
    }
}

// MARK: - CustomPageVCDelegate

extension HomeVC: CustomPageVCDelegate {
    func didScroll(xScroll: CGFloat, direction: ScrollPageDirection) {
        
    }

    func didEndScroll(newPage: Int) {
        let indexPath = IndexPath(item: newPage, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.updateIndicator(indexPath: indexPath)
    }
}

extension HomeVC: ListFilmDelegate {
    func didSelectMovie(movie: Movie) {
        MovieDetailVC.push(from: self, animated: true) { vc in
            vc.movieId = movie.id
            vc.delegate = self
        } completion: {
            
        }
    }
    
    func didTapFavorite(movie: Movie, isFavorite: Bool) {
        viewModel.updateFavoriteMovie(movie: movie, isFavorite: isFavorite)
        viewControllers.forEach {
            $0.updateFavoriteMovie(id: movie.id, isFavorite: isFavorite)
        }
        self.showToastFavorite(isFavorite: isFavorite)
    }
}

// MARK: - MovieDetailVCDelegate

extension HomeVC: MovieDetailVCDelegate {
    func didUpdateFavoriteMovie(id: Int, isFavorite: Bool) {
        viewControllers.forEach {
            $0.updateFavoriteMovie(id: id, isFavorite: isFavorite)
        }
    }
}
