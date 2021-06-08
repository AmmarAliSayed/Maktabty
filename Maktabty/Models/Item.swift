//
//  Item.swift
//  Maktabty
//
//  Created by Macbook on 18/05/2021.
//

import Foundation
class Item {
    var id: String!
    var itemName: String!
    var numberOfCopies: Int!
    var price: Double!
    var imageLinks: [String]!
    
    init() {
        
    }
    init(_dictionary: NSDictionary) {
        id = _dictionary[K.ItemsFStore.itemIdField] as? String
        itemName = _dictionary[K.ItemsFStore.itemNameField] as? String
        imageLinks = _dictionary[K.ItemsFStore.imageLinksField] as? [String]
        numberOfCopies = _dictionary[K.ItemsFStore.numberOfCopiesField] as? Int
        price = _dictionary[K.ItemsFStore.priceField] as? Double
    }
}
//MARK: Helper functions

func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.id,  item.itemName,item.price,item.numberOfCopies, item.imageLinks ], forKeys: [K.ItemsFStore.itemIdField as NSCopying, K.ItemsFStore.itemNameField as NSCopying, K.ItemsFStore.priceField as NSCopying, K.ItemsFStore.numberOfCopiesField as NSCopying, K.ItemsFStore.imageLinksField as NSCopying])
}
