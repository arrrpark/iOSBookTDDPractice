//
//  BookmarkCollectionView.swift
//  BookTDDSample
//
//  Created by Arrr Park on 12/05/2022.
//

import UIKit
import Kingfisher

protocol BookmarkCollectionViewDelegate: AnyObject {
    func bookmarkCollectionView(_ collectionView: BookmarkCollectionView, didSelectItemAt indexPath: IndexPath)
}

class BookmarkCollectionView: UICollectionView {
    weak var viewDelegate: BookmarkCollectionViewDelegate?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(BookCell.self, forCellWithReuseIdentifier: String(describing: BookCell.self))
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookmarkCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.bookmarkCollectionView(self, didSelectItemAt: indexPath)
    }
}

extension BookmarkCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Global.bookmarks.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: BookCell.self), for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }
        
        let data = Global.bookmarks.value[indexPath.row]
        cell.configWithBook(data)
        return cell
    }
}

extension BookmarkCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100)
    }
}


