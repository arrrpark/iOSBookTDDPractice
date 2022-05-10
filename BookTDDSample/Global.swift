//
//  Global.swift
//  BookTDDSample
//
//  Created by Arrr Park on 10/05/2022.
//

import UIKit
import Combine

struct Global {
    static var bookmarks = CurrentValueSubject<[Book], Never>(BookmarkDAO.shared.findBookmarks())
}
