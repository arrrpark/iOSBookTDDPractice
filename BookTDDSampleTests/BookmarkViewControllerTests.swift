//
//  BookmarkViewControllerTEsts.swift
//  BookTDDSampleTests
//
//  Created by Arrr Park on 12/05/2022.
//

import XCTest
import Combine
import Alamofire
import Kingfisher
@testable import BookTDDSample

class BookmarkViewControllerTests: XCTestCase {
    var bookmarkViewController: BookmarkViewController!
    
    override func setUpWithError() throws {
        bookmarkViewController = BookmarkViewController()
        bookmarkViewController.viewDidLoad()
    }

    override func tearDownWithError() throws {
        bookmarkViewController = nil
    }
    
    func testBookmark_flowlayout() {
        let bookmarkCollectinViewFlowLayout = bookmarkViewController.bookmarkCollectinViewFlowLayout
        
        XCTAssertNotNil(bookmarkCollectinViewFlowLayout)
        XCTAssertTrue(bookmarkCollectinViewFlowLayout.scrollDirection == .vertical)
        XCTAssertTrue(bookmarkCollectinViewFlowLayout.minimumLineSpacing == 0)
        XCTAssertTrue(bookmarkCollectinViewFlowLayout.minimumInteritemSpacing == 0)
    }
    
    func testBookmark_collectionView() {
        let bookmarkCollectionView = bookmarkViewController.bookmarkCollectionView
        
        XCTAssertNotNil(bookmarkCollectionView)
        XCTAssertTrue(bookmarkCollectionView.backgroundColor == .clear)
    }
    
    func testBookmark_collectionViewCell() {
        let bookmarkCollectionView = MockBookmarkCollectionView(frame: .zero, collectionViewLayout: bookmarkViewController.bookmarkCollectinViewFlowLayout)
        
        var expectations: [XCTestExpectation] = []
        
        FakeData.bookmarks.value.indices.forEach { index in
            let cell = bookmarkCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BookCell.self), for: IndexPath(row: index, section: 0)) as! BookCell
            let book = FakeData.bookmarks.value[index]
            
            cell.configWithBook(book)
            XCTAssertTrue(cell.titleLabel.text == book.title)
            XCTAssertTrue(cell.subTitleLabel.text == book.subTitle)
            XCTAssertTrue(cell.isbn13Label.text == book.isbn13)
            XCTAssertTrue(cell.priceLabel.text == book.price)
            
            let expectation = self.expectation(description: "expect image \(index)")
            expectations.append(expectation)
                            
            cell.getImageFromURL(book.image).sink(receiveCompletion: { _ in
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
        
        wait(for: expectations, timeout: 3)
    }
    
    func testBookmark_NavigateToDetail() {
        let bookmarkViewController = MockBookmarkViewController()
        
        let bookmarkCollectionView = MockBookmarkCollectionView(frame: .zero, collectionViewLayout: bookmarkViewController.bookmarkCollectinViewFlowLayout)
        
        bookmarkCollectionView.viewDelegate = bookmarkViewController
        bookmarkViewController.view.addSubview(bookmarkCollectionView)
        
        let navigationController = MockNavigationController(rootViewController: bookmarkViewController)
        
        FakeData.bookmarks.value.indices.forEach { index in
            let cell = bookmarkCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BookCell.self), for: IndexPath(row: index, section: 0)) as! BookCell
            
            cell.configWithBook(FakeData.bookmarks.value[index])
        }
        
        bookmarkCollectionView.collectionView(bookmarkCollectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(navigationController.pushedViewController is DetailBookViewController)
    }
    
}

class MockBookmarkViewController: BookmarkViewController {
    override func bookmarkCollectionView(_ collectionView: BookmarkCollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailBookViewModel = DetailBookViewModel(book: FakeData.bookmarks.value[indexPath.row])
        let controller = DetailBookViewController(detailBookViewModel: detailBookViewModel)
        navigationController?.pushViewController(controller, animated: true)
    }
}

class MockBookmarkCollectionView: BookmarkCollectionView {
    override func numberOfItems(inSection section: Int) -> Int {
        return FakeData.bookmarks.value.count
    }
    
    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: BookCell.self), for: indexPath) as? BookCell else {
            return UICollectionViewCell()
        }
        
        let data = FakeData.bookmarks.value[indexPath.item]
        cell.configWithBook(data)
        return cell
    }
}
