//
//  Basket.swift
//  Maktabty
//
//  Created by Macbook on 24/05/2021.
//

import Foundation
class Basket {
    var basketId: String!
    var ownerId: String!
    var orderItemsIds: [String] = []
    var orderBooksIds: [String] = []
    var orderNovelsIds: [String] = []
    init() {
        
    }
    init(_dictionary: NSDictionary) {
        basketId = _dictionary[K.BasketFStore.basketIdField] as? String
        ownerId = _dictionary[K.BasketFStore.ownerIdField] as? String
        orderItemsIds = _dictionary[K.BasketFStore.orderItemsIds] as! [String]
        orderBooksIds = _dictionary[K.BasketFStore.orderBooksIds] as! [String]
        orderNovelsIds = _dictionary[K.BasketFStore.orderNovelsIds] as! [String]
    }
}


