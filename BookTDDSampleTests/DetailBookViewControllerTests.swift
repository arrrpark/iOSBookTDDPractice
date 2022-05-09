//
//  DetailBookViewControllerTests.swift
//  BookTDDSampleTests
//
//  Created by Arrr Park on 09/05/2022.
//

import XCTest
import Combine
import Alamofire
import Kingfisher
@testable import BookTDDSample

class DetailBookViewControllerTests: XCTestCase {
    var detailBookViewController: DetailBookViewController!
    var detailBookViewModel: DetailBookProtocol!
    
    let book = Book(title: "title",
                    subTitle: "subTitle",
                    isbn13: "isbn13",
                    price: "15",
                    image: "https://itbook.store/img/books/9781617294471.png",
                    url: nil)
    
    let bookDetail = BookDetail(title: "Mastering Kafka Streams and ksqlDB",
                                subTitle: "Building Real-Time Data Systems by Example",
                                authors: "Mitch Seymour",
                                publisher: "O'Reilly Media",
                                language: "English",
                                isbn10: "1492062499",
                                isbn13: "9781492062493",
                                pages: "434",
                                year: "2021",
                                rating: "4",
                                desc: "Working with unbounded and fast-moving data streams has historically been difficult. But with Kafka Streams and ksqlDB, building stream processing applications is easy and fun. This practical guide shows data engineers how to use these tools to build highly scalable stream processing applications fo...",
                                price: "$52.88",
                                image: "https://itbook.store/img/books/9781492062493.png",
                                url: "https://itbook.store/books/9781492062493")
    
    override func setUpWithError() throws {
        detailBookViewModel = DetailBookViewModel(book: book)
        detailBookViewController = DetailBookViewController(detailBookViewModel: detailBookViewModel)
        detailBookViewController.viewDidLoad()
    }

    override func tearDownWithError() throws {
        detailBookViewModel = nil
        detailBookViewController = nil
    }
    
    func testDetailBookViewController_setting() {
        XCTAssertNotNil(detailBookViewController.optionBar)
        XCTAssertTrue(detailBookViewController.optionBar.backgroundColor == .white)
        
        XCTAssertNotNil(detailBookViewController.backButton)
        XCTAssertTrue(UIImage.equal(lhs: detailBookViewController.backButton.image(for: .normal),
                                    rhs: UIImage(systemName:"arrow.left")))
        
        XCTAssertNotNil(detailBookViewController.bookImageView)
        XCTAssertTrue(detailBookViewController.bookImageView.contentMode == .scaleAspectFit)
        
        XCTAssertNotNil(detailBookViewController.titleLabel)
        XCTAssertTrue(detailBookViewController.titleLabel.textColor == .black)
        XCTAssertTrue(detailBookViewController.titleLabel.numberOfLines == 0)
        XCTAssertTrue(detailBookViewController.titleLabel.font == UIFont.boldSystemFont(ofSize: 15))
        
        XCTAssertNotNil(detailBookViewController.subTitleLabel)
        XCTAssertTrue(detailBookViewController.subTitleLabel.textColor == .black)
        XCTAssertTrue(detailBookViewController.subTitleLabel.font == UIFont.systemFont(ofSize: 12))
        
        XCTAssertNotNil(detailBookViewController.authorsLabel)
        XCTAssertTrue(detailBookViewController.authorsLabel.textColor == .black)
        XCTAssertTrue(detailBookViewController.authorsLabel.font == UIFont.systemFont(ofSize: 12))
        
        XCTAssertNotNil(detailBookViewController.publisherLabel)
        XCTAssertTrue(detailBookViewController.publisherLabel.textColor == .black)
        XCTAssertTrue(detailBookViewController.publisherLabel.font == UIFont.systemFont(ofSize: 12))
        
        XCTAssertNotNil(detailBookViewController.languageLabel)
        XCTAssertTrue(detailBookViewController.languageLabel.textColor == .black)
        XCTAssertTrue(detailBookViewController.languageLabel.font == UIFont.systemFont(ofSize: 12))
        
        XCTAssertNotNil(detailBookViewController.isbn10Label)
        XCTAssertTrue(detailBookViewController.isbn10Label.textColor == .black)
        XCTAssertTrue(detailBookViewController.isbn10Label.font == UIFont.systemFont(ofSize: 12))
        
        XCTAssertNotNil(detailBookViewController.isbn13Label)
        XCTAssertTrue(detailBookViewController.isbn13Label.textColor == .black)
        XCTAssertTrue(detailBookViewController.isbn13Label.font == UIFont.systemFont(ofSize: 12))
        
        XCTAssertNotNil(detailBookViewController.pagesLabel)
        XCTAssertTrue(detailBookViewController.pagesLabel.textColor == .black)
        XCTAssertTrue(detailBookViewController.pagesLabel.font == UIFont.systemFont(ofSize: 12))
        
        XCTAssertNotNil(detailBookViewController.yearLabel)
        XCTAssertTrue(detailBookViewController.yearLabel.textColor == .black)
        XCTAssertTrue(detailBookViewController.yearLabel.font == UIFont.systemFont(ofSize: 12))
        
        XCTAssertNotNil(detailBookViewController.descLabel)
        XCTAssertTrue(detailBookViewController.descLabel.textColor == .black)
        XCTAssertTrue(detailBookViewController.descLabel.font == UIFont.systemFont(ofSize: 12))
        
        XCTAssertNotNil(detailBookViewController.priceLabel)
        XCTAssertTrue(detailBookViewController.priceLabel.textColor == .black)
        XCTAssertTrue(detailBookViewController.priceLabel.font == UIFont.systemFont(ofSize: 12))
        
        XCTAssertNotNil(detailBookViewController.bookmarkButton)
        XCTAssertTrue(detailBookViewController.bookmarkButton.title(for: .normal) == "Bookmark")
        XCTAssertTrue(detailBookViewController.bookmarkButton.titleColor(for: .normal) == .white)
        XCTAssertTrue(detailBookViewController.bookmarkButton.backgroundColor == .darkGray)
        XCTAssertTrue(detailBookViewController.bookmarkButton.isHidden == true)
    }
    
    func test_configDetail() {
        detailBookViewController.configBookDetail(bookDetail)
        
        XCTAssertTrue(detailBookViewController.titleLabel.text == bookDetail.title)
        XCTAssertTrue(detailBookViewController.subTitleLabel.text == bookDetail.subTitle)
        XCTAssertTrue(detailBookViewController.authorsLabel.text == bookDetail.authors)
        XCTAssertTrue(detailBookViewController.publisherLabel.text == bookDetail.publisher)
        XCTAssertTrue(detailBookViewController.languageLabel.text == bookDetail.language)
        XCTAssertTrue(detailBookViewController.isbn10Label.text == "isbn10 : \(bookDetail.isbn10!)")
        XCTAssertTrue(detailBookViewController.isbn13Label.text == "isbn13 : \(bookDetail.isbn13!)")
        XCTAssertTrue(detailBookViewController.pagesLabel.text == "pages : \(bookDetail.pages!)")
        XCTAssertTrue(detailBookViewController.yearLabel.text == "year : \(bookDetail.year!)")
        XCTAssertTrue(detailBookViewController.descLabel.text == bookDetail.desc)
        XCTAssertTrue(detailBookViewController.priceLabel.text == "price : \(bookDetail.price!)")
        XCTAssertTrue(detailBookViewController.bookmarkButton.isHidden == false)
        
        let expectation = expectation(description: "image expect")
        detailBookViewModel.getImageFromURL(bookDetail.image).sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] result in
            guard let image1Data = self?.detailBookViewController.bookImageView.image?.pngData(),
                  let image2Data = result?.pngData() else {
                XCTFail("Image not equal")
                return
            }
            XCTAssertTrue(image1Data.elementsEqual(image2Data))
            expectation.fulfill()
        }).store(in: &detailBookViewController.cancelBag)
        waitForExpectations(timeout: 3)
    }
    
    func testDetail_BackPressedCalled() {
        let detailBookViewController = MockDetailBookViewController(detailBookViewModel: DetailBookViewModel(book: book))
        
        detailBookViewController.backButton.sendActions(for: .touchUpInside)
        detailBookViewController.backPressedCalled = true
    }
}

class MockDetailBookViewController: DetailBookViewController {
    public var backPressedCalled = false
    
    override func onBackPressed() {
        backPressedCalled = true
        super.onBackPressed()
    }
}
