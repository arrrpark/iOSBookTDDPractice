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
        
        XCTAssertTrue(button.title(for: .normal) == "Go")
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
        searchBookViewModel.books.append(FakeData.book)
        searchBookViewController.searchBookCollectionView.reloadData()
        XCTAssertTrue(searchBookViewController.searchBookCollectionView.numberOfItems(inSection: 0) == 1)
    }
    
    func testSearchBookCollectionView_cell() {
        let collectionView = searchBookViewController.searchBookCollectionView
        searchBookViewModel.books.append(FakeData.book)
        
        collectionView.reloadData()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BookCell.self), for: IndexPath(row: 0, section: 0)) as! BookCell
        XCTAssertNotNil(cell)
        XCTAssertNotNil(cell.imageView)
        XCTAssertNotNil(cell.titleLabel)
        XCTAssertNotNil(cell.subTitleLabel)
        XCTAssertNotNil(cell.isbn13Label)
        XCTAssertNotNil(cell.priceLabel)
        
        let book = FakeData.book
        
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

class MockSearchBookViewModel: SearchBookViewModel {
    override func searchBooks(_ word: String) -> Future<SearchResult, NetworkError> {
        return Future<SearchResult, NetworkError> { promise in
            guard let data = FakeData.books.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let result = SearchResult(JSON: json)else {
                promise(.failure(.badForm))
                return
            }
            promise(.success(result))
        }
    }
}
