//
//  AppDelegate.swift
//  CustomPageVC
//
//  Created by Tung Phan on 28/01/2023.
//

import UIKit
import Rswift

enum ScrollPageDirection {
    case left, right
}

protocol CustomPageVCDelegate: AnyObject {
    func didScroll(xScroll: CGFloat, direction: ScrollPageDirection)
    func didEndScroll(newPage: Int)
}

class CustomPageVC: UIViewController {

    // MARK: - Variables
    var allViewControllers = [UIViewController]()
    var currentIndex: Int = 0
    var startOffset: CGFloat = 0
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.isPagingEnabled = true
        v.bounces = false
        return v
    }()
    let stack: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.distribution = .fillEqually
        return v
    }()
    weak var delegate: CustomPageVCDelegate?
    var lastContentOffset: CGFloat = 0

    class func initPage(viewControllers: [UIViewController]) -> CustomPageVC {
        let pageVC = CustomPageVC(nibName: R.nib.customPageVC.name, bundle: nil)
        pageVC.allViewControllers = viewControllers
        return pageVC
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(stack)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false

        view.addSubview(scrollView)

        let svCLG = scrollView.contentLayoutGuide
        let svFLG = scrollView.frameLayoutGuide

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),

            stack.topAnchor.constraint(equalTo: svCLG.topAnchor, constant: 0.0),
            stack.leadingAnchor.constraint(equalTo: svCLG.leadingAnchor, constant: 0.0),
            stack.trailingAnchor.constraint(equalTo: svCLG.trailingAnchor, constant: 0.0),
            stack.bottomAnchor.constraint(equalTo: svCLG.bottomAnchor, constant: 0.0),

            stack.heightAnchor.constraint(equalTo: svFLG.heightAnchor, constant: 0.0)

        ])
        allViewControllers.forEach { vc in
            self.addChild(vc)
            stack.addArrangedSubview(vc.view)
            vc.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: 0.0).isActive = true
            vc.didMove(toParent: self)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scroll(index: currentIndex)
    }

    func scroll(index: Int) {
        let x: CGFloat = CGFloat(index) * view.bounds.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

}

extension CustomPageVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffset > scrollView.contentOffset.x {
            delegate?.didScroll(xScroll: scrollView.contentOffset.x, direction: .left)
        } else {
            delegate?.didScroll(xScroll: scrollView.contentOffset.x, direction: .right)
        }
        lastContentOffset = scrollView.contentOffset.x
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / view.bounds.width)
        if index != currentIndex {
            delegate?.didEndScroll(newPage: index)
        }
        currentIndex = index
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index: Int = Int(scrollView.contentOffset.x / view.bounds.width)
        if index != currentIndex {
            delegate?.didEndScroll(newPage: index)
        }
        currentIndex = index
    }
}
