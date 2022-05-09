//
//  SearchResult.swift
//  BookTDDSample
//
//  Created by Arrr Park on 08/05/2022.
//

import Foundation
import ObjectMapper

struct SearchResult: Mappable {
    var total: String?
    var page: String?
    var books: [Book]?
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        total <- map["total"]
        page <- map["page"]
        books <- map["books"]
    }
}
