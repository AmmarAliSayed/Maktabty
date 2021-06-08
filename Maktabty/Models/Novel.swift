//
//  Novel.swift
//  Maktabty
//
//  Created by Macbook on 17/05/2021.
//

import Foundation

class Novel {
    
    var id: String!
    var novelName: String!
    var authorName: String!
    var numberOfCopies: Int!
    var price: Double!
    var numberOfPages: Int!
    var languge: String!
    var imageLinks: [String]!
    init() {
        
    }
    init(_dictionary: NSDictionary) {
        id = _dictionary[K.NovelsFStore.novelIdField] as? String
        novelName = _dictionary[K.NovelsFStore.novelNameField] as? String
        imageLinks = _dictionary[K.NovelsFStore.imageLinksField] as? [String]
        authorName = _dictionary[K.NovelsFStore.authorNameField] as? String
        numberOfCopies = _dictionary[K.NovelsFStore.numberOfCopiesField] as? Int
        price = _dictionary[K.NovelsFStore.priceField] as? Double
        numberOfPages = _dictionary[K.NovelsFStore.numberOfPagesField] as? Int
        languge = _dictionary[K.NovelsFStore.langugeField] as? String
    }
}

//MARK: Helper functions

func novelDictionaryFrom(_ novel: Novel) -> NSDictionary {
    
    return NSDictionary(objects: [novel.id, novel.numberOfPages, novel.novelName, novel.authorName, novel.price,novel.numberOfCopies, novel.imageLinks ,novel.languge], forKeys: [K.NovelsFStore.novelIdField as NSCopying, K.NovelsFStore.numberOfPagesField as NSCopying, K.NovelsFStore.novelNameField as NSCopying, K.NovelsFStore.authorNameField as NSCopying, K.NovelsFStore.priceField as NSCopying, K.NovelsFStore.numberOfCopiesField as NSCopying , K.NovelsFStore.imageLinksField as NSCopying , K.NovelsFStore.langugeField as NSCopying])
}
