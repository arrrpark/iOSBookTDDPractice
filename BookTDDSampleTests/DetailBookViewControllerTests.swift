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
    
    override func setUpWithError() throws {
        detailBookViewModel = DetailBookViewModel(book: FakeData.book)
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
        let bookDetail = FakeData.bookDetail
        
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
        let detailBookViewController = MockDetailBookViewController(detailBookViewModel: DetailBookViewModel(book: FakeData.book))
        
        detailBookViewController.backButton.sendActions(for: .touchUpInside)
        detailBookViewController.backPressedCalled = true
    }
    
    func testDetail_findBookmark() {
        let book = FakeData.book
        
        let detailViewModel = MockDetailBookViewModel(book: book)
        let detailBookViewController = DetailBookViewController(detailBookViewModel: detailViewModel)
        detailBookViewController.viewDidLoad()
        
        XCTAssertNil(detailViewModel.findABook(book.isbn13))
        detailViewModel.addBookmark(book)
        XCTAssertNotNil(detailViewModel.findABook(book.isbn13))
        detailViewModel.cancelBookmark(book.isbn13)
        XCTAssertNil(detailViewModel.findABook(book.isbn13))
    }
    
    func testDetail_addRemoveBookmark() {
        let book = FakeData.book
        
        let detailViewModel = MockDetailBookViewModel(book: book)
        let detailBookViewController = DetailBookViewController(detailBookViewModel: detailViewModel)
        detailBookViewController.viewDidLoad()
        
        XCTAssertFalse(detailViewModel.isBookmarked(book.isbn13))
        detailViewModel.addBookmark(book)
        XCTAssertTrue(detailViewModel.isBookmarked(book.isbn13))
        detailViewModel.cancelBookmark(book.isbn13)
        XCTAssertFalse(detailViewModel.isBookmarked(book.isbn13))
    }
    
    func testDetail_BookmarkPressed() {
        let book = FakeData.book
        
        let detailViewModel = MockDetailBookViewModel(book: book)
        let detailBookViewController = DetailBookViewController(detailBookViewModel: detailViewModel)
        detailBookViewController.viewDidLoad()
        
        XCTAssertTrue(detailBookViewController.bookmarkButton.title(for: .normal) == "Bookmark")
        detailBookViewController.bookmarkButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(detailBookViewController.bookmarkButton.title(for: .normal) == "Cancel bookmark")
        detailBookViewController.bookmarkButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(detailBookViewController.bookmarkButton.title(for: .normal) == "Bookmark")
    }
}

class MockDetailBookViewController: DetailBookViewController {
    public var backPressedCalled = false
    
    override func onBackPressed() {
        backPressedCalled = true
        super.onBackPressed()
    }
}

class MockDetailBookViewModel: DetailBookViewModel {
    func findABook(_ isbn13: String?) -> Book? {
        guard let isbn13 = isbn13 else { return nil }
        return FakeData.bookmarks.value.first(where: { $0.isbn13 == isbn13 })
    }
    
    
    override func isBookmarked(_ isbn13: String?) -> Bool {
        guard let isbn13 = isbn13 else { return false }
        return findABook(isbn13) != nil
    }
    
    @discardableResult
    override func addBookmark(_ book: Book) -> Bool {
        var bookmarks = FakeData.bookmarks.value
        bookmarks.append(book)
        FakeData.bookmarks.send(bookmarks)
        return true
    }
    
    @discardableResult
    override func cancelBookmark(_ isbn13: String?) -> Bool {
        guard let isbn13 = isbn13,
              let index = FakeData.bookmarks.value.firstIndex(where: { $0.isbn13 == isbn13}) else {
            return false
        }
        
        var bookmarks = FakeData.bookmarks.value
        bookmarks.remove(at: index)
        FakeData.bookmarks.send(bookmarks)
        return true
    }
}
