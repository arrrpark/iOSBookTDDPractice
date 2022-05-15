//
//  BookTDDSampleUITests.swift
//  BookTDDSampleUITests
//
//  Created by Arrr Park on 08/05/2022.
//

import XCTest

class BookTDDSampleUITests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func test_bookmark() throws {
        let app = XCUIApplication()
        app.launch()

        let wordTextField = app.textFields["Word"]
        wordTextField.tap()
        wordTextField.typeText("kafka")
        app.buttons["Go"].tap()
        sleep(2)

        let searchBookCollectionView = app.collectionViews["searchBookCollectionView"]
        let resultCells = searchBookCollectionView.children(matching: .cell)
        searchBookCollectionView.swipeUp()
        resultCells.element(boundBy: resultCells.count - 1).tap()
        app.buttons["detailBookmark"].tap()
        app.buttons["detailBack"].tap()
        app.buttons["bookmarkTap"].tap()
        
        let bookmarkCollectionView = app.collectionViews["bookmarkCollectionView"]
        let bookmarkCells = bookmarkCollectionView.children(matching: .cell)
        XCTAssertTrue(bookmarkCollectionView.cells.count == 1)
        
        bookmarkCells.element(boundBy: 0).tap()
        app.buttons["detailBookmark"].tap()
        app.buttons["detailBack"].tap()
        XCTAssertTrue(bookmarkCollectionView.cells.count == 0)
    }
}
