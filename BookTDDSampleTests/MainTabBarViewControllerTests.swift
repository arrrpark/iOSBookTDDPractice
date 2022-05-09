//
//  BookTDDSampleTests.swift
//  BookTDDSampleTests
//
//  Created by Arrr Park on 08/05/2022.
//

import XCTest
@testable import BookTDDSample

class MainTabBarViewControllerTests: XCTestCase {
    
    var navigationViewController: NavigationViewController!
    var mainTabBarViewController: MainTabBarViewController!
    
    override func setUpWithError() throws {
        mainTabBarViewController = MainTabBarViewController()
        navigationViewController = NavigationViewController(rootViewController: mainTabBarViewController)
    }

    override func tearDownWithError() throws {
        mainTabBarViewController = nil
        navigationViewController = nil
    }

    func testNavigationController_setting() {
        navigationViewController.viewDidLoad()
        XCTAssertTrue(navigationViewController.viewControllers[0] is MainTabBarViewController)
        XCTAssertTrue(navigationViewController.navigationBar.isHidden == true)
    }

    func testMainTabBarController_shouldHaveTwoTab() {
        mainTabBarViewController.viewDidLoad()
        XCTAssertTrue(mainTabBarViewController.viewControllers?.count == 2)
        XCTAssertTrue(mainTabBarViewController.viewControllers?[0] is SearchBookViewController)
        XCTAssertTrue(mainTabBarViewController.viewControllers?[1] is BookmarkViewController)

        XCTAssertTrue(mainTabBarViewController.viewControllers?[0].tabBarItem.title == "Search")
        XCTAssertTrue(mainTabBarViewController.viewControllers?[0].tabBarItem.image == nil)
        XCTAssertTrue(mainTabBarViewController.viewControllers?[0].tabBarItem.tag == 0)
        
        XCTAssertTrue(mainTabBarViewController.viewControllers?[1].tabBarItem.title == "Bookmark")
        XCTAssertTrue(mainTabBarViewController.viewControllers?[1].tabBarItem.image == nil)
        XCTAssertTrue(mainTabBarViewController.viewControllers?[1].tabBarItem.tag == 1)
    }
    
}
