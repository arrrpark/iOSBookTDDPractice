//
//  BookmarkViewController.swift
//  BookTDDSample
//
//  Created by Arrr Park on 08/05/2022.
//

import UIKit
import Then
import SnapKit
import Combine

class BookmarkViewController: AppbaseViewController, BookmarkCollectionViewDelegate {
    var cancelBag = Set<AnyCancellable>()
    
    lazy var bookmarkCollectinViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var bookmarkCollectionView = BookmarkCollectionView(frame: .zero, collectionViewLayout: bookmarkCollectinViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.viewDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(bookmarkCollectionView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        bookmarkCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Util.shared.getSafeAreaTopBottom().top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Util.shared.getSafeAreaTopBottom().bottom)
        }
    }
    
    func bookmarkCollectionView(_ collectionView: BookmarkCollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailBookViewModel = DetailBookViewModel(book: Global.bookmarks.value[indexPath.row])
        let controller = DetailBookViewController(detailBookViewModel: detailBookViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//extension BookmarkViewController: BookmarkCollectionViewDelegate {
//    func bookmarkCollectionView(_ collectionView: BookmarkCollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailBookViewModel = DetailBookViewModel(book: Global.bookmarks.value[indexPath.row])
//        let controller = DetailBookViewController(detailBookViewModel: detailBookViewModel)
//        navigationController?.pushViewController(controller, animated: true)
//    }
//}
