//
//  SearchBookViewControllerTests.swift
//  BookTDDSampleTests
//
//  Created by Arrr Park on 08/05/2022.
//

import XCTest
import Combine
import Alamofire
import Kingfisher
@testable import BookTDDSample

class SearchBookViewControllerTests: XCTestCase {
    
    var searchBookViewController: SearchBookViewController!
    var searchBookViewModel: SearchBookProtocol!
    
    let book = Book(title: "title",
                    subTitle: "subTitle",
                    isbn13: "isbn13",
                    price: "15",
                    image: "https://itbook.store/img/books/9781617294471.png",
                    url: nil)
    
    override func setUpWithError() throws {
        searchBookViewModel = SearchBookViewModel()
        searchBookViewController = SearchBookViewController(searchBookViewModel: searchBookViewModel)
        searchBookViewController.viewDidLoad()
    }

    override func tearDownWithError() throws {
        searchBookViewController = nil
    }

    func testSearchBookViewController_searchTextField() {
        XCTAssertNotNil(searchBookViewController.searchTextField)
        XCTAssertTrue(searchBookViewController.searchTextField.borderStyle == .roundedRect)
        XCTAssertTrue(searchBookViewController.searchTextField.font == UIFont.systemFont(ofSize: 15))
    }
    
    func testSearchBookViewController_searchButton() {
        let button = searchBookViewController.searchButton
        
        XCTAssertTrue(button.title(for: .normal) == "Search")
        XCTAssertTrue(button.backgroundColor == .lightGray)
        XCTAssertTrue(button.layer.cornerRadius == 10)
        XCTAssertTrue(button.clipsToBounds == true)
    }
    
    func testSearchBookViewController_searchCollectionView() {
        let collectionView = searchBookViewController.searchBookCollectionView
        let flowLayout = searchBookViewController.searchBookFlowLayout
        
        XCTAssertNotNil(collectionView)
        XCTAssertTrue(collectionView.backgroundColor == .clear)
        XCTAssertTrue(collectionView.collectionViewLayout == flowLayout)
        XCTAssertTrue(flowLayout.minimumLineSpacing == 0)
        XCTAssertTrue(flowLayout.minimumInteritemSpacing == 0)
        XCTAssertTrue(flowLayout.scrollDirection == .vertical)
    }
    
    func testSearchBookViewController_initialData() {
        searchBookViewController.viewDidLoad()
        
        XCTAssertTrue(searchBookViewController.searchBookViewModel.books.count == 0)
        XCTAssertTrue(searchBookViewController.searchBookViewModel.isFetching == false)
        XCTAssertTrue(searchBookViewController.searchBookViewModel.pageIndex == 0)
        XCTAssertTrue(searchBookViewController.searchBookViewModel.totalPage == 0)
        XCTAssertTrue(searchBookViewController.searchBookViewModel.word == "")
    }
    
    func testSearchBookDataProvider_numberOfSections() {
        XCTAssertTrue(searchBookViewController.searchBookCollectionView.numberOfSections == 1)
    }
    
    func testSearchBookCollectionView_numOfDatas() {
        XCTAssertTrue(searchBookViewController.searchBookCollectionView.numberOfItems(inSection: 0) == 0)
        searchBookViewModel.books.append(book)
        searchBookViewController.searchBookCollectionView.reloadData()
        XCTAssertTrue(searchBookViewController.searchBookCollectionView.numberOfItems(inSection: 0) == 1)
    }
    
    func testSearchBookCollectionView_cell() {
        let collectionView = searchBookViewController.searchBookCollectionView
        searchBookViewModel.books.append(book)
        
        collectionView.reloadData()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BookCell.self), for: IndexPath(row: 0, section: 0)) as! BookCell
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.imageView)
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.subTitleLabel)
        XCTAssertNotNil(cell.isbn13Label)
        XCTAssertNotNil(cell.priceLabel)
        
        cell.configWithBook(book)
        XCTAssertTrue(cell.titleLabel.text == book.title)
        XCTAssertTrue(cell.subTitleLabel.text == book.subTitle)
        XCTAssertTrue(cell.isbn13Label.text == book.isbn13)
        XCTAssertTrue(cell.priceLabel.text == book.price)
        
        let expectation = expectation(description: "image expect")
        cell.getImageFromURL(book.image).sink(receiveCompletion: { _ in
        }, receiveValue: { result in
            guard let image1Data = cell.imageView.image?.pngData(),
                  let image2Data = result?.pngData() else {
                XCTFail("Image not equal")
                return
            }
            XCTAssertTrue(image1Data.elementsEqual(image2Data))
            expectation.fulfill()
        }).store(in: &searchBookViewController.cancelBag)
        waitForExpectations(timeout: 3)
    }
    
    func testSearchBook_mock() {
        let mockViewModel = MockSearchBookViewModel()
        let mockViewController = SearchBookViewController(searchBookViewModel: mockViewModel)
        
        var expectations: [XCTestExpectation] = []
        
        mockViewModel.searchBooks("kafka").sink(receiveCompletion: { _ in
        }, receiveValue: { [weak self] result in
            XCTAssertTrue(Int(result.page ?? "") == 1)
            guard let self = self,
                  let books = result.books else {
                XCTFail("No books")
                return
            }
            mockViewModel.books = books
            mockViewController.searchBookCollectionView.reloadData()
            
            for (index, element) in books.enumerated() {
                let cell = mockViewController.searchBookCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BookCell.self), for: IndexPath(row: 0, section: index)) as! BookCell
                
                cell.configWithBook(element)
                XCTAssertTrue(cell.titleLabel.text == element.title)
                XCTAssertTrue(cell.subTitleLabel.text == element.subTitle)
                XCTAssertTrue(cell.isbn13Label.text == element.isbn13)
                XCTAssertTrue(cell.priceLabel.text == element.price)
                
                let expectation = self.expectation(description: "expect image \(index)")
                expectations.append(expectation)
                
                cell.getImageFromURL(element.image).sink(receiveCompletion: { _ in
                }, receiveValue: { result in
                    guard let image2Data = result?.pngData(),
                          let image1Data = cell.imageView.image?.pngData() else {
                        XCTFail("Image not equal")
                        return
                    }
                    XCTAssertTrue(image1Data.elementsEqual(image2Data))
                    expectation.fulfill()
                }).store(in: &cell.cancelBag)
            }
        }).store(in: &searchBookViewController.cancelBag)
        wait(for: expectations, timeout: 3)
    }
    
    // integration test
    func testSearchBook_ThenNavigateToDetail() {
        let navigationController = MockNavigationController(rootViewController: MainTabBarViewController())

        let mainTabBarViewController = navigationController.viewControllers[0] as! MainTabBarViewController
        mainTabBarViewController.viewDidLoad()

        let searchBookViewController = mainTabBarViewController.viewControllers?[0] as! SearchBookViewController
        let expectation = expectation(description: "search book expect")
        
        searchBookViewController.searchBookViewModel.searchBooks("kafka").sink(receiveCompletion: { _ in
        }, receiveValue: { result in
            XCTAssertTrue(Int(result.page ?? "") == 1)
            guard let books = result.books else {
                XCTFail("No books")
                return
            }
            searchBookViewController.searchBookViewModel.books = books
            searchBookViewController.searchBookCollectionView.reloadData()
            
            XCTAssertTrue(navigationController.viewControllers.count == 1)
            
            for (index, element) in books.enumerated() {
                let cell = searchBookViewController.searchBookCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BookCell.self), for: IndexPath(row: 0, section: index)) as! BookCell
                
                cell.configWithBook(element)
            }
            
            searchBookViewController.searchBookCollectionView.collectionView(searchBookViewController.searchBookCollectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
            
            XCTAssertTrue(navigationController.pushedViewController is DetailBookViewController)
            expectation.fulfill()
        }).store(in: &searchBookViewController.cancelBag)
        
        waitForExpectations(timeout: 3)
    }
}

class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class MockSearchBookViewModel: SearchBookViewModel {
    let mockData = """
    {\"error\":\"0\",\"total\":\"27\",\"page\":\"1\",\"books\":[{\"title\":\"Kafka Streams in Action\",\"subtitle\":\"Real-time apps and microservices with the Kafka Streams API\",\"isbn13\":\"9781617294471\",\"price\":\"$34.99\",\"image\":\"https://itbook.store/img/books/9781617294471.png\",\"url\":\"https://itbook.store/books/9781617294471\"},{\"title\":\"Apache Kafka\",\"subtitle\":\"Set up Apache Kafka clusters and develop custom message producers and consumers using practical, hands-on examples\",\"isbn13\":\"9781782167938\",\"price\":\"$20.99\",\"image\":\"https://itbook.store/img/books/9781782167938.png\",\"url\":\"https://itbook.store/books/9781782167938\"},{\"title\":\"Learning Apache Kafka, 2nd Edition\",\"subtitle\":\"Start from scratch and learn how to administer Apache Kafka effectively for messaging\",\"isbn13\":\"9781784393090\",\"price\":\"$20.99\",\"image\":\"https://itbook.store/img/books/9781784393090.png\",\"url\":\"https://itbook.store/books/9781784393090\"},{\"title\":\"Apache Kafka Quick Start Guide\",\"subtitle\":\"Leverage Apache Kafka 2.0 to simplify real-time data processing for distributed applications\",\"isbn13\":\"9781788997829\",\"price\":\"$29.99\",\"image\":\"https://itbook.store/img/books/9781788997829.png\",\"url\":\"https://itbook.store/books/9781788997829\"},{\"title\":\"Kafka: The Definitive Guide\",\"subtitle\":\"Real-Time Data and Stream Processing at Scale\",\"isbn13\":\"9781491936160\",\"price\":\"$17.00\",\"image\":\"https://itbook.store/img/books/9781491936160.png\",\"url\":\"https://itbook.store/books/9781491936160\"},{\"title\":\"Mastering Kafka Streams and ksqlDB\",\"subtitle\":\"Building Real-Time Data Systems by Example\",\"isbn13\":\"9781492062493\",\"price\":\"$52.88\",\"image\":\"https://itbook.store/img/books/9781492062493.png\",\"url\":\"https://itbook.store/books/9781492062493\"},{\"title\":\"Event Streams in Action\",\"subtitle\":\"Real-time event systems with Kafka and Kinesis\",\"isbn13\":\"9781617292347\",\"price\":\"$23.70\",\"image\":\"https://itbook.store/img/books/9781617292347.png\",\"url\":\"https://itbook.store/books/9781617292347\"},{\"title\":\"Kafka in Action\",\"subtitle\":\"\",\"isbn13\":\"9781617295232\",\"price\":\"$44.99\",\"image\":\"https://itbook.store/img/books/9781617295232.png\",\"url\":\"https://itbook.store/books/9781617295232\"},{\"title\":\"Professional Hadoop\",\"subtitle\":\"\",\"isbn13\":\"9781119267171\",\"price\":\"$34.32\",\"image\":\"https://itbook.store/img/books/9781119267171.png\",\"url\":\"https://itbook.store/books/9781119267171\"},{\"title\":\"JSON at Work\",\"subtitle\":\"Practical Data Integration for the Web\",\"isbn13\":\"9781449358327\",\"price\":\"$40.49\",\"image\":\"https://itbook.store/img/books/9781449358327.png\",\"url\":\"https://itbook.store/books/9781449358327\"}]}
    """

    override func searchBooks(_ word: String) -> Future<SearchResult, NetworkError> {
        return Future<SearchResult, NetworkError> { [weak self] promise in
            guard let data = self?.mockData.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let result = SearchResult(JSON: json)else {
                promise(.failure(.badForm))
                return
            }
            promise(.success(result))
        }
    }
}
