//
//  SearchBookViewModel.swift
//  BookTDDSample
//
//  Created by Arrr Park on 08/05/2022.
//

import Foundation
import Combine
import Alamofire

protocol SearchBookProtocol: AnyObject {
    var books: [Book] { get set }
    
    var isFetching: Bool { get set }
    var pageIndex: Int { get set }
    var totalPage: Int { get set }
    var word: String { get set }
    
    func searchBooks(_ word: String) -> Future<SearchResult, NetworkError>
    func fetchMore() -> Future<SearchResult, NetworkError>
    func canFetchMore() -> Bool
}

class SearchBookViewModel: SearchBookProtocol {
    var books: [Book] = []
    
    var isFetching = false
    var pageIndex = 0
    var totalPage = 0
    var word = ""
    
    func searchBooks(_ word: String) -> Future<SearchResult, NetworkError> {
        return AlamofireWrapper.shared.byGet(url: "1.0/search/\(word)")
    }
    
    func fetchMore() -> Future<SearchResult, NetworkError> {
        return AlamofireWrapper.shared.byGet(url: "1.0/search/\(self.word)/\(self.pageIndex)")
    }
    
    func canFetchMore() -> Bool {
        return !isFetching && pageIndex < totalPage
    }
}
