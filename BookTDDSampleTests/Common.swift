//
//  FakeData.swift
//  BookTDDSampleTests
//
//  Created by Arrr Park on 15/05/2022.
//

import UIKit
import Combine
@testable import BookTDDSample

struct FakeData {
    private init() { }
    
    static let book = Book(title: "title",
                           subTitle: "subTitle",
                           isbn13: "isbn13",
                           price: "15",
                           image: "https://itbook.store/img/books/9781617294471.png",
                           url: nil)
    
    static let bookDetail = BookDetail(title: "Mastering Kafka Streams and ksqlDB",
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
    
    static let books = """
        {\"error\":\"0\",\"total\":\"27\",\"page\":\"1\",\"books\":[{\"title\":\"Kafka Streams in Action\",\"subtitle\":\"Real-time apps and microservices with the Kafka Streams API\",\"isbn13\":\"9781617294471\",\"price\":\"$34.99\",\"image\":\"https://itbook.store/img/books/9781617294471.png\",\"url\":\"https://itbook.store/books/9781617294471\"},{\"title\":\"Apache Kafka\",\"subtitle\":\"Set up Apache Kafka clusters and develop custom message producers and consumers using practical, hands-on examples\",\"isbn13\":\"9781782167938\",\"price\":\"$20.99\",\"image\":\"https://itbook.store/img/books/9781782167938.png\",\"url\":\"https://itbook.store/books/9781782167938\"},{\"title\":\"Learning Apache Kafka, 2nd Edition\",\"subtitle\":\"Start from scratch and learn how to administer Apache Kafka effectively for messaging\",\"isbn13\":\"9781784393090\",\"price\":\"$20.99\",\"image\":\"https://itbook.store/img/books/9781784393090.png\",\"url\":\"https://itbook.store/books/9781784393090\"},{\"title\":\"Apache Kafka Quick Start Guide\",\"subtitle\":\"Leverage Apache Kafka 2.0 to simplify real-time data processing for distributed applications\",\"isbn13\":\"9781788997829\",\"price\":\"$29.99\",\"image\":\"https://itbook.store/img/books/9781788997829.png\",\"url\":\"https://itbook.store/books/9781788997829\"},{\"title\":\"Kafka: The Definitive Guide\",\"subtitle\":\"Real-Time Data and Stream Processing at Scale\",\"isbn13\":\"9781491936160\",\"price\":\"$17.00\",\"image\":\"https://itbook.store/img/books/9781491936160.png\",\"url\":\"https://itbook.store/books/9781491936160\"},{\"title\":\"Mastering Kafka Streams and ksqlDB\",\"subtitle\":\"Building Real-Time Data Systems by Example\",\"isbn13\":\"9781492062493\",\"price\":\"$52.88\",\"image\":\"https://itbook.store/img/books/9781492062493.png\",\"url\":\"https://itbook.store/books/9781492062493\"},{\"title\":\"Event Streams in Action\",\"subtitle\":\"Real-time event systems with Kafka and Kinesis\",\"isbn13\":\"9781617292347\",\"price\":\"$23.70\",\"image\":\"https://itbook.store/img/books/9781617292347.png\",\"url\":\"https://itbook.store/books/9781617292347\"},{\"title\":\"Kafka in Action\",\"subtitle\":\"\",\"isbn13\":\"9781617295232\",\"price\":\"$44.99\",\"image\":\"https://itbook.store/img/books/9781617295232.png\",\"url\":\"https://itbook.store/books/9781617295232\"},{\"title\":\"Professional Hadoop\",\"subtitle\":\"\",\"isbn13\":\"9781119267171\",\"price\":\"$34.32\",\"image\":\"https://itbook.store/img/books/9781119267171.png\",\"url\":\"https://itbook.store/books/9781119267171\"},{\"title\":\"JSON at Work\",\"subtitle\":\"Practical Data Integration for the Web\",\"isbn13\":\"9781449358327\",\"price\":\"$40.49\",\"image\":\"https://itbook.store/img/books/9781449358327.png\",\"url\":\"https://itbook.store/books/9781449358327\"}]}
        """
    
    static let mockBooks: [Book] = {
        let data = FakeData.books.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        let result = SearchResult(JSON: json)!.books!
        return result
    }()
    
    static let bookmarks = CurrentValueSubject<[Book], Never>(FakeData.mockBooks)
}

class MockNavigationController: UINavigationController {
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}
