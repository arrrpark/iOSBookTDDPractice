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
    
    func testDetail_findBookmark() {
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
    static let mockBookData = """
    {\"error\":\"0\",\"total\":\"27\",\"page\":\"1\",\"books\":[{\"title\":\"Kafka Streams in Action\",\"subtitle\":\"Real-time apps and microservices with the Kafka Streams API\",\"isbn13\":\"9781617294471\",\"price\":\"$34.99\",\"image\":\"https://itbook.store/img/books/9781617294471.png\",\"url\":\"https://itbook.store/books/9781617294471\"},{\"title\":\"Apache Kafka\",\"subtitle\":\"Set up Apache Kafka clusters and develop custom message producers and consumers using practical, hands-on examples\",\"isbn13\":\"9781782167938\",\"price\":\"$20.99\",\"image\":\"https://itbook.store/img/books/9781782167938.png\",\"url\":\"https://itbook.store/books/9781782167938\"},{\"title\":\"Learning Apache Kafka, 2nd Edition\",\"subtitle\":\"Start from scratch and learn how to administer Apache Kafka effectively for messaging\",\"isbn13\":\"9781784393090\",\"price\":\"$20.99\",\"image\":\"https://itbook.store/img/books/9781784393090.png\",\"url\":\"https://itbook.store/books/9781784393090\"},{\"title\":\"Apache Kafka Quick Start Guide\",\"subtitle\":\"Leverage Apache Kafka 2.0 to simplify real-time data processing for distributed applications\",\"isbn13\":\"9781788997829\",\"price\":\"$29.99\",\"image\":\"https://itbook.store/img/books/9781788997829.png\",\"url\":\"https://itbook.store/books/9781788997829\"},{\"title\":\"Kafka: The Definitive Guide\",\"subtitle\":\"Real-Time Data and Stream Processing at Scale\",\"isbn13\":\"9781491936160\",\"price\":\"$17.00\",\"image\":\"https://itbook.store/img/books/9781491936160.png\",\"url\":\"https://itbook.store/books/9781491936160\"},{\"title\":\"Mastering Kafka Streams and ksqlDB\",\"subtitle\":\"Building Real-Time Data Systems by Example\",\"isbn13\":\"9781492062493\",\"price\":\"$52.88\",\"image\":\"https://itbook.store/img/books/9781492062493.png\",\"url\":\"https://itbook.store/books/9781492062493\"},{\"title\":\"Event Streams in Action\",\"subtitle\":\"Real-time event systems with Kafka and Kinesis\",\"isbn13\":\"9781617292347\",\"price\":\"$23.70\",\"image\":\"https://itbook.store/img/books/9781617292347.png\",\"url\":\"https://itbook.store/books/9781617292347\"},{\"title\":\"Kafka in Action\",\"subtitle\":\"\",\"isbn13\":\"9781617295232\",\"price\":\"$44.99\",\"image\":\"https://itbook.store/img/books/9781617295232.png\",\"url\":\"https://itbook.store/books/9781617295232\"},{\"title\":\"Professional Hadoop\",\"subtitle\":\"\",\"isbn13\":\"9781119267171\",\"price\":\"$34.32\",\"image\":\"https://itbook.store/img/books/9781119267171.png\",\"url\":\"https://itbook.store/books/9781119267171\"},{\"title\":\"JSON at Work\",\"subtitle\":\"Practical Data Integration for the Web\",\"isbn13\":\"9781449358327\",\"price\":\"$40.49\",\"image\":\"https://itbook.store/img/books/9781449358327.png\",\"url\":\"https://itbook.store/books/9781449358327\"}]}
    """
    
    static let mockBooks: [Book] = {
        let data = MockDetailBookViewModel.mockBookData.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        let result = SearchResult(JSON: json)!.books!
        return result
    }()
    
    static let bookmarks = CurrentValueSubject<[Book], Never>(MockDetailBookViewModel.mockBooks)

    func findABook(_ isbn13: String?) -> Book? {
        guard let isbn13 = isbn13 else { return nil }

        return MockDetailBookViewModel.bookmarks.value.first(where: { $0.isbn13 == isbn13 })
    }
    
    
    override func isBookmarked(_ isbn13: String?) -> Bool {
        guard let isbn13 = isbn13 else { return false }
        return findABook(isbn13) != nil
    }
    
    @discardableResult
    override func addBookmark(_ book: Book) -> Bool {
        var bookmarks = MockDetailBookViewModel.bookmarks.value
        bookmarks.append(book)
        MockDetailBookViewModel.bookmarks.send(bookmarks)
        return true
    }
    
    @discardableResult
    override func cancelBookmark(_ isbn13: String?) -> Bool {
        guard let isbn13 = isbn13,
              let index = MockDetailBookViewModel.bookmarks.value.firstIndex(where: { $0.isbn13 == isbn13}) else {
            return false
        }
        
        var bookmarks = MockDetailBookViewModel.bookmarks.value
        bookmarks.remove(at: index)
        MockDetailBookViewModel.bookmarks.send(bookmarks)
        return true
    }
}
