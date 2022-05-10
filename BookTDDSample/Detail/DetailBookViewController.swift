//
//  DetailBookViewController.swift
//  BookTDDSample
//
//  Created by Arrr Park on 09/05/2022.
//


import UIKit
import SnapKit
import Kingfisher
import Then
import Combine

class DetailBookViewController: AppbaseViewController {
    var cancelBag = Set<AnyCancellable>()
    
    let detailBookViewModel: DetailBookProtocol
    
    lazy var optionBar = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var backButton = UIButton().setImageButton(UIImage(systemName: "arrow.left")).then {
        $0.publisher(for: .touchUpInside).sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] _ in
            self?.onBackPressed()
        }).store(in: &cancelBag)
    }
    
    lazy var bookImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    lazy var subTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var authorsLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var publisherLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var languageLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var isbn10Label = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var isbn13Label = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var pagesLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var yearLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var descLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.numberOfLines = 0
    }
    
    lazy var priceLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
    }
    
    lazy var bookmarkButton = UIButton().then {
        $0.setTitle("Bookmark", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .darkGray
        $0.isHidden = true
        $0.publisher(for: .touchUpInside).sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] _ in
            self?.onBookmarkPressed()
        }).store(in: &cancelBag)
        
    }
    
    init(detailBookViewModel: DetailBookProtocol) {
        self.detailBookViewModel = detailBookViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailBookViewModel.getBookDetail().sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] detail in
            self?.configBookDetail(detail)
        }).store(in: &cancelBag)
    }
    
    override func setupViews() {
        super.setupViews()
        
        view.addSubview(optionBar)
        optionBar.addSubview(backButton)
        
        view.addSubview(bookImageView)
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(authorsLabel)
        view.addSubview(publisherLabel)
        view.addSubview(languageLabel)
        view.addSubview(isbn10Label)
        view.addSubview(isbn13Label)
        view.addSubview(pagesLabel)
        view.addSubview(yearLabel)
        view.addSubview(descLabel)
        view.addSubview(priceLabel)
        view.addSubview(bookmarkButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        optionBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Util.shared.getSafeAreaTopBottom().top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        bookImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(optionBar.snp.bottom).offset(10)
            make.size.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(bookImageView)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(bookImageView.snp.bottom).offset(5)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        authorsLabel.snp.makeConstraints { make in
            make.leading.equalTo(subTitleLabel)
            make.trailing.equalTo(subTitleLabel)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(5)
        }
        
        publisherLabel.snp.makeConstraints { make in
            make.leading.equalTo(authorsLabel)
            make.trailing.equalTo(authorsLabel)
            make.top.equalTo(authorsLabel.snp.bottom).offset(5)
        }
        
        languageLabel.snp.makeConstraints { make in
            make.leading.equalTo(publisherLabel)
            make.trailing.equalTo(publisherLabel)
            make.top.equalTo(publisherLabel.snp.bottom).offset(5)
        }
        
        isbn10Label.snp.makeConstraints { make in
            make.leading.equalTo(languageLabel)
            make.trailing.equalTo(languageLabel)
            make.top.equalTo(languageLabel.snp.bottom).offset(5)
        }
        
        isbn13Label.snp.makeConstraints { make in
            make.leading.equalTo(isbn10Label)
            make.trailing.equalTo(isbn10Label)
            make.top.equalTo(isbn10Label.snp.bottom).offset(5)
        }
        
        pagesLabel.snp.makeConstraints { make in
            make.leading.equalTo(isbn13Label)
            make.trailing.equalTo(isbn13Label)
            make.top.equalTo(isbn13Label.snp.bottom).offset(5)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.leading.equalTo(pagesLabel)
            make.trailing.equalTo(pagesLabel)
            make.top.equalTo(pagesLabel.snp.bottom).offset(5)
        }
        
        descLabel.snp.makeConstraints { make in
            make.leading.equalTo(yearLabel)
            make.trailing.equalTo(yearLabel)
            make.top.equalTo(yearLabel.snp.bottom).offset(5)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(descLabel)
            make.trailing.equalTo(descLabel)
            make.top.equalTo(descLabel.snp.bottom).offset(5)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel)
            make.top.equalTo(priceLabel.snp.bottom).offset(5)
        }
    }
    
    func onBackPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    func configBookDetail(_ bookDetail: BookDetail) {
        detailBookViewModel.getImageFromURL(bookDetail.image).sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] image in
            self?.bookImageView.image = image
        }).store(in: &cancelBag)
        
        titleLabel.text = bookDetail.title
        subTitleLabel.text = bookDetail.subTitle
        authorsLabel.text = bookDetail.authors
        publisherLabel.text = bookDetail.publisher
        languageLabel.text = bookDetail.language
        if let isbn10 = bookDetail.isbn10 { isbn10Label.text = "isbn10 : \(isbn10)" }
        if let isbn13 = bookDetail.isbn13 { isbn13Label.text = "isbn13 : \(isbn13)" }
        if let pages = bookDetail.pages { pagesLabel.text = "pages : \(pages)" }
        if let year = bookDetail.year { yearLabel.text = "year : \(year)" }
        descLabel.text = bookDetail.desc
        if let price = bookDetail.price { priceLabel.text = "price : \(price)" }
        bookmarkButton.isHidden = false
    }
    
    func onBookmarkPressed() {
        if detailBookViewModel.isBookmarked(detailBookViewModel.book.isbn13) {
            if detailBookViewModel.cancelBookmark(detailBookViewModel.book.isbn13) {
                bookmarkButton.setTitle("Bookmark", for: .normal)
            }
        } else {
            if detailBookViewModel.addBookmark(detailBookViewModel.book) {
                bookmarkButton.setTitle("Cancel bookmark", for: .normal)
            }
        }
    }
}
    
