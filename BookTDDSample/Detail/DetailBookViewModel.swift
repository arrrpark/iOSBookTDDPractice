//
//  DetailBookProtocol.swift
//  BookTDDSample
//
//  Created by Arrr Park on 09/05/2022.
//

import UIKit
import Combine
import Kingfisher

protocol DetailBookProtocol {
    var book: Book { get }
    
    func isBookmarked(_ isbn13: String?) -> Bool
    func addBookmark(_ book: Book) -> Bool
    func cancelBookmark(_ isbn13: String?) -> Bool
    func getBookDetail() -> Future<BookDetail, NetworkError>
    func getImageFromURL(_ url: String?) -> Future<UIImage?, Error>
}

class DetailBookViewModel: DetailBookProtocol {
    let book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    func isBookmarked(_ isbn13: String?) -> Bool {
        guard let isbn13 = isbn13 else { return false }
        return BookmarkDAO.shared.findABook(isbn13) != nil
    }
    
    func addBookmark(_ book: Book) -> Bool {
        var books = Global.bookmarks.value
        books.append(book)
        Global.bookmarks.send(books)
        return BookmarkDAO.shared.addBookmark(book)
    }
    
    func cancelBookmark(_ isbn13: String?) -> Bool {
        var books = Global.bookmarks.value
        if let index = books.firstIndex(where: { $0.isbn13 == isbn13 }) {
            books.remove(at: index)
            Global.bookmarks.send(books)
        }
        return BookmarkDAO.shared.cancelBookmark(isbn13)
    }
    
    func getBookDetail() -> Future<BookDetail, NetworkError> {
        guard let isbn13 = book.isbn13 else {
            return Future<BookDetail, NetworkError> { promise in
            promise(.failure(NetworkError.badForm))
        }}
        
        return AlamofireWrapper.shared.byGet(url: "1.0/books/\(isbn13)")
    }
    
    func getImageFromURL(_ url: String?) -> Future<UIImage?, Error> {
        return Future<UIImage?, Error> { promise in
            guard let url = URL(string: url ?? "") else {
                promise(.success(nil))
                return
            }
            let resource = ImageResource(downloadURL: url)
            
            KingfisherManager.shared.retrieveImage(with: resource) { result in
                switch result {
                case .success(let image):
                    promise(.success(image.image))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
}
