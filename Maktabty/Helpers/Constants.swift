//
//  Constants.swift
//  Maktabty
//
//  Created by Macbook on 09/05/2021.
//

import Foundation



struct K {
//    static let appName = "⚡️FlashChat"
//    static let cellIdentifier = "ReusableCell"
//    static let cellNibName = "MessageTableViewCell"
//    static let registerSegue = "RegisterToChat"
//    static let loginSegue = "LoginToChat"
    
    //Firestore
    struct BooksFStore {
        static let collectionName = "Books"
        static let bookIdField = "bookId"
        static let bookNameField = "bookName"
        static let authorNameField = "authorName"
        static let numberOfCopiesField = "numberOfCopies"
        static let priceField = "price"
        static let numberOfPagesField = "numberOfPages"
        static let langugeField = "languge"
        static let imageLinksField = "images"
    }
    struct NovelsFStore {
        static let collectionName = "Novels"
        static let novelIdField = "novelId"
        static let novelNameField = "novelName"
        static let authorNameField = "authorName"
        static let numberOfCopiesField = "numberOfCopies"
        static let priceField = "price"
        static let numberOfPagesField = "numberOfPages"
        static let langugeField = "languge"
        static let imageLinksField = "images"
    }
    
    struct ItemsFStore {
        static let collectionName = "Items"
        static let itemIdField = "itemId"
        static let itemNameField = "itemName"
        static let numberOfCopiesField = "numberOfCopies"
        static let priceField = "price"
        static let imageLinksField = "images"
    }
    struct UsersFStore {
        static let collectionName = "Users"
        static let userIdField = "userId"
        static let userNameField = "userName"
        static let phoneField = "phone"
        static let emailField = "email"
        static let imageLinksField = "imageLinks"

    }
    struct BasketFStore {
        static let collectionName = "Basket"
        static let basketIdField = "basketId"
        static let ownerIdField = "ownerId"
        static let orderItemsIds = "orderItemsIds"
        static let orderBooksIds = "orderBooksIds"
        static let orderNovelsIds = "orderNovelsIds"
    }
    struct UserDefaultsData{
        static let userName = "userName"
        static let email = "email"
        static let CURRENTUSER  = "currentUser"
    }
    //Storage
    struct Storage {
        static let folderPath = "gs://maktabty-e62b6.appspot.com"
    }
    struct Algolia {
        static let SEARCH_KEY = "02e9f327da3450168fde5bfd199d0366"
        static let ADMIN_KEY = "d0552c184c1cc732f8f36beb895536d2"
        static let  APP_ID = "E4PMX7QKY1"
    }
}
