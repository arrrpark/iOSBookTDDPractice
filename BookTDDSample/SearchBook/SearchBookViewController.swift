//
//  SearchBookViewController.swift
//  BookTDDSample
//
//  Created by Arrr Park on 08/05/2022.
//

import UIKit
import Then
import SnapKit
import Combine

class SearchBookViewController: AppbaseViewController {
    let searchBookViewModel: SearchBookProtocol
    
    var cancelBag = Set<AnyCancellable>()
    
    lazy var searchTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.font = UIFont.systemFont(ofSize: 15)
    }
    
    lazy var searchButton = UIButton().then {
        $0.setTitle("Search", for: .normal)
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.publisher(for: .touchUpInside).sink(receiveValue: { [weak self] _ in
            guard let self = self,
                  let word = self.searchTextField.text, word.count > 0 else { return }
            
            self.searchBookViewModel.searchBooks(word).sink(receiveCompletion: { _ in
            },receiveValue: { [weak self] result in
                guard let books = result.books else { return }
                
                self?.searchBookViewModel.books = books
                self?.searchBookCollectionView.reloadData()
            }).store(in: &self.cancelBag)
        }).store(in: &cancelBag)
    }
    
    lazy var searchBookFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
    }
    
    lazy var searchBookCollectionView = SearchBookCollectionView(frame: .zero, collectionViewLayout: searchBookFlowLayout, searchBookViewModel: searchBookViewModel).then {
        $0.backgroundColor = .clear
        $0.viewDelegate = self
    }
    
    init(searchBookViewModel: SearchBookProtocol) {
        self.searchBookViewModel = searchBookViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        searchBookViewModel.searchBooks("Kafka").sink(receiveCompletion: { _ in
//
//        }, receiveValue: { [weak self] result in
//            print(result.books?.count)
//            self?.searchBookViewModel.books = result.books!
//            self?.searchBookCollectionView.reloadData()
//
//        }).store(in: &cancelBag)
    }
    
    override func setupViews() {
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(searchBookCollectionView)
    }
    
    override func setupConstraints() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Util.shared.getSafeAreaTopBottom().top)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(searchTextField)
            make.leading.equalTo(searchTextField.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(searchTextField)
        }
        
        searchBookCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Util.shared.getSafeAreaTopBottom().bottom)
        }
    }
}

extension SearchBookViewController: SearchBookCollectionViewDelegate {
    func searchBookCollectionView(_ collectionView: SearchBookCollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == searchBookViewModel.books.count - 1,
//           searchBookViewModel.canFetchMore() {
//            searchBookViewModel.isFetching = true
//            showIndicator()
//            searchBookViewModel.fetchMore().subscribe({ [weak self] event in
//                self?.searchBookViewModel.isFetching = false
//                self?.hideIndicator()
//                switch event {
//                case .success(let books):
//                    self?.searchBookViewModel.books.append(contentsOf: books)
//                    self?.searchBookViewModel.pageIndex += 1
//                    self?.searchBookCollectionView.reloadData()
//                case .failure:
//                    break
//                }
//            }).disposed(by: disposeBag)
//        }
    }
    
    func searchBookCollectionView(_ collectionView: SearchBookCollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailBookViewModel = DetailBookViewModel(book: searchBookViewModel.books[indexPath.row])
        let controller = DetailBookViewController(detailBookViewModel: detailBookViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}
