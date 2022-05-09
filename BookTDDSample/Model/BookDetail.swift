//
//  BookDetail.swift
//  BookTDDSample
//
//  Created by Arrr Park on 09/05/2022.
//

import Foundation
import ObjectMapper

struct BookDetail: Mappable {
    var title: String?
    var subTitle: String?
    var authors: String?
    var publisher: String?
    var language: String?
    var isbn10: String?
    var isbn13: String?
    var pages : String?
    var year: String?
    var rating: String?
    var desc: String?
    var price: String?
    var image: String?
    var url: String?
    
    init(title: String?,
         subTitle: String?,
         authors: String?,
         publisher: String?,
         language: String?,
         isbn10: String?,
         isbn13: String?,
         pages: String?,
         year: String?,
         rating: String?,
         desc: String?,
         price: String?,
         image: String?,
         url: String?) {
        self.title = title
        self.subTitle = subTitle
        self.authors = authors
        self.publisher = publisher
        self.language = language
        self.isbn10 = isbn10
        self.isbn13 = isbn13
        self.pages = pages
        self.year = year
        self.rating = rating
        self.desc = desc
        self.price = price
        self.image = image
        self.url = url
    }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        subTitle <- map["subTitle"]
        authors <- map["authors"]
        publisher <- map["publisher"]
        language <- map["language"]
        isbn10 <- map["isbn10"]
        isbn13 <- map["isbn13"]
        pages <- map["pages"]
        year <- map["year"]
        rating <- map["rating"]
        desc <- map["desc"]
        price <- map["price"]
        image <- map["image"]
        url <- map["url"]
    }
}
