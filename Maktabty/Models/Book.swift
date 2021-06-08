//
//  Book.swift
//  Maktabty
//
//  Created by Macbook on 09/05/2021.
//

import Foundation
class Book {
    var id: String!
    var bookName: String!
    var authorName: String!
    var numberOfCopies: Int!
    var price: Double!
    var numberOfPages: Int!
    var languge: String!
    var imageLinks: [String]!
    
    init() {
        
    }
    init(_dictionary: NSDictionary) {
        id = _dictionary[K.BooksFStore.bookIdField] as? String
        bookName = _dictionary[K.BooksFStore.bookNameField] as? String
        imageLinks = _dictionary[K.BooksFStore.imageLinksField] as? [String]
        authorName = _dictionary[K.BooksFStore.authorNameField] as? String
        numberOfCopies = _dictionary[K.BooksFStore.numberOfCopiesField] as? Int
        price = _dictionary[K.BooksFStore.priceField] as? Double
        numberOfPages = _dictionary[K.BooksFStore.numberOfPagesField] as? Int
        languge = _dictionary[K.BooksFStore.langugeField] as? String
    }
    
}

//MARK: Helper functions

func bookDictionaryFrom(_ book: Book) -> NSDictionary {
    
    return NSDictionary(objects: [book.id, book.numberOfPages, book.bookName, book.authorName, book.price,book.numberOfCopies, book.imageLinks ,book.languge], forKeys: [K.BooksFStore.bookIdField as NSCopying, K.BooksFStore.numberOfPagesField as NSCopying, K.BooksFStore.bookNameField as NSCopying, K.BooksFStore.authorNameField as NSCopying, K.BooksFStore.priceField as NSCopying, K.BooksFStore.numberOfCopiesField as NSCopying , K.BooksFStore.imageLinksField as NSCopying , K.BooksFStore.langugeField as NSCopying])
}
