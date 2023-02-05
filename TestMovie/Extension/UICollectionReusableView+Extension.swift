//
//  UICollectionReusableView+Extension.swift
//  TestMovie
//
//  Created by Tung Phan on 28/01/2023.
//  Copyright © 2019 tnu. All rights reserved.
//

import UIKit

// MARK: - UICollectionReusableView (Header & Footer)
enum XibCollectionSupplementaryKind {
    case header, footer
    
    var kind: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

protocol XibCollectionSupplementary {
    static var name: String { get }
    static func registerTo(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind)
    static func reusableFor(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind, at indexPath: IndexPath) -> Self?
}

extension XibCollectionSupplementary where Self: UICollectionReusableView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func registerTo(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind) {
        collectionView.register(Self.self, forSupplementaryViewOfKind: kind.kind, withReuseIdentifier: name)
    }
    
    static func reusableFor(collectionView: UICollectionView, forKind kind: XibCollectionSupplementaryKind, at indexPath: IndexPath) -> Self? {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind.kind, withReuseIdentifier: name, for: indexPath) as? Self
    }
}

extension UICollectionReusableView: XibCollectionSupplementary { }
