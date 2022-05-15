//
//  ViewController.swift
//  BookTDDSample
//
//  Created by Arrr Park on 08/05/2022.
//

import UIKit
import SnapKit
import Then

class MainTabBarViewController: UITabBarController {

    lazy var searchBookViewController = SearchBookViewController(searchBookViewModel: SearchBookViewModel()).then {
        $0.tabBarItem = UITabBarItem(title: "Search", image: nil, tag: 0)
        $0.accessibilityLabel = "searchBookTap"
    }
    
    lazy var bookmarkViewController = BookmarkViewController().then {
        $0.tabBarItem = UITabBarItem(title: "Bookmark", image: nil, tag: 1)
        $0.accessibilityLabel = "bookmarkTap"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [searchBookViewController, bookmarkViewController]
    }
}

