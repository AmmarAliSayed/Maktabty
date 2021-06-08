//
//  FireStore.swift
//  Maktabty
//
//  Created by Macbook on 09/05/2021.
//

import Foundation
import FirebaseAuth
//MARK: - BookFirestore
func saveBookToFirestore(_ book: Book) {
    
    getFirebaseReference(.Books).document(book.id).setData([K.BooksFStore.bookNameField : book.bookName , K.BooksFStore.bookIdField : book.id , K.BooksFStore.authorNameField : book.authorName , K.BooksFStore.numberOfCopiesField : book.numberOfCopies , K.BooksFStore.numberOfPagesField : book.numberOfPages , K.BooksFStore.priceField : book.price , K.BooksFStore.langugeField : book.languge , K.BooksFStore.imageLinksField : book.imageLinks]) { (error) in
        if let e = error {
            print("there is an error in saving data to fireStore \(e)")
        }else {
            print("successifly saving data to fireStore")
        }
    }
}

func retrieveBooksFromFirebase(completion: @escaping (_ bookArray: [Book]) -> Void) {
    
    var booksArr: [Book] = []
    
    getFirebaseReference(.Books).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(booksArr)
            return
        }
        
        if !snapshot.isEmpty {
            
            for doc in snapshot.documents {
                // print(doc.data())
                let data = doc.data()
                if let bookName = data[K.BooksFStore.bookNameField] as? String ,let  images = data [K.BooksFStore.imageLinksField]as? [String] , let bookId =  data[K.BooksFStore.bookIdField] as? String , let authorName = data[K.BooksFStore.authorNameField] as? String ,  let price = data[K.BooksFStore.priceField] as? Double , let langauge = data[K.BooksFStore.langugeField] as? String , let numberOfCopies = data[K.BooksFStore.numberOfCopiesField] as? Int , let numberOfPages = data[K.BooksFStore.numberOfPagesField] as? Int{
                  //  let book = Book(id: bookId, bookName: bookName, authorName: authorName, numberOfCopies: numberOfCopies, price: price, numberOfPages: numberOfPages, languge: langauge, imageLinks: images)
                    let book = Book()
                    book.id  = bookId
                    book.bookName = bookName
                    book.authorName = authorName
                    book.languge = langauge
                    book.imageLinks = images
                    book.numberOfCopies = numberOfCopies
                    book.numberOfPages = numberOfPages
                    book.price = price
                    
                    booksArr.append(book)
                }
               
            }
        }
        
        completion(booksArr)
    }
    
}

//MARK: - NovelFirestore
func saveNovelToFirestore(_ novel: Novel) {
    
    getFirebaseReference(.Novels).document(novel.id).setData([K.NovelsFStore.novelNameField : novel.novelName , K.NovelsFStore.novelIdField : novel.id , K.NovelsFStore.authorNameField : novel.authorName , K.NovelsFStore.numberOfCopiesField : novel.numberOfCopies , K.NovelsFStore.numberOfPagesField : novel.numberOfPages , K.NovelsFStore.priceField : novel.price , K.NovelsFStore.langugeField : novel.languge , K.NovelsFStore.imageLinksField : novel.imageLinks]) { (error) in
        if let e = error {
            print("there is an error in saving data to fireStore \(e)")
        }else {
            print("successifly saving data to fireStore")
        }
    }
}

func retrieveNovelsFromFirebase(completion: @escaping (_ novelArray: [Novel]) -> Void) {
    
    var novelsArr: [Novel] = []
    
    getFirebaseReference(.Novels).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(novelsArr)
            return
        }
        
        if !snapshot.isEmpty {
            
            for doc in snapshot.documents {
                // print(doc.data())
                let data = doc.data()
                if let novelName = data[K.NovelsFStore.novelNameField] as? String ,let  images = data [K.NovelsFStore.imageLinksField]as? [String] , let novelId =  data[K.NovelsFStore.novelIdField] as? String , let authorName = data[K.NovelsFStore.authorNameField] as? String ,  let price = data[K.NovelsFStore.priceField] as? Double , let langauge = data[K.NovelsFStore.langugeField] as? String , let numberOfCopies = data[K.NovelsFStore.numberOfCopiesField] as? Int , let numberOfPages = data[K.NovelsFStore.numberOfPagesField] as? Int{
                   // let novel = Novel(id: novelId, novelName: novelName, authorName: authorName, numberOfCopies: numberOfCopies, price: price, numberOfPages: numberOfPages, languge: langauge, imageLinks: images)
                    let novel = Novel()
                    novel.id  = novelId
                    novel.novelName = novelName
                    novel.authorName = authorName
                    novel.languge = langauge
                    novel.imageLinks = images
                    novel.numberOfCopies = numberOfCopies
                    novel.numberOfPages = numberOfPages
                    novel.price = price
                    novelsArr.append(novel)
                }
               
            }
        }
        
        completion(novelsArr)
    }
    
}
//MARK: - ItemFirestore
func saveItemToFirestore(_ item: Item) {
    
    getFirebaseReference(.Items).document(item.id).setData([K.ItemsFStore.itemNameField :item.itemName , K.ItemsFStore.itemIdField : item.id ,  K.ItemsFStore.numberOfCopiesField : item.numberOfCopies ,  K.ItemsFStore.priceField : item.price , K.ItemsFStore.imageLinksField : item.imageLinks]) { (error) in
        if let e = error {
            print("there is an error in saving data to fireStore \(e)")
        }else {
            print("successifly saving data to fireStore")
        }
    }
}

func retrieveItemsFromFirebase(completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var itemsArr: [Item] = []
    
    getFirebaseReference(.Items).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(itemsArr)
            return
        }
        
        if !snapshot.isEmpty {
            
            for doc in snapshot.documents {
                // print(doc.data())
                let data = doc.data()
                if let itemName = data[K.ItemsFStore.itemNameField] as? String ,let  images = data [K.ItemsFStore.imageLinksField]as? [String] , let itemId =  data[K.ItemsFStore.itemIdField] as? String ,  let price = data[K.ItemsFStore.priceField] as? Double  , let numberOfCopies = data[K.ItemsFStore.numberOfCopiesField] as? Int {
                 //   let item = Item(id: itemId, itemName: itemName, numberOfCopies: numberOfCopies, price: price, imageLinks: images)
                    var item = Item()
                    item.id  = itemId
                    item.itemName = itemName
                    item.imageLinks = images
                    item.numberOfCopies = numberOfCopies
                    item.price = price
                    itemsArr.append(item)
                }
               
            }
        }
        
        completion(itemsArr)
    }
    
}


//MARK: - User
// create user collection in firestore
func saveUserToFirestore(user: User) {
    
    getFirebaseReference(.Users).document(user.userId).setData([K.UsersFStore.userIdField :user.userId ,   K.UsersFStore.userNameField : user.name ,  K.UsersFStore.phoneField : user.phone , K.UsersFStore.emailField : user.email ,  K.UsersFStore.imageLinksField : user.imageLinks])  { (error) in
        
        if error != nil {
            print("error saving user \(error!.localizedDescription)")
        }
    }
}



func retriveUserFromFirestore(userId: String, completion: @escaping (_ user: User?) -> Void) {

    getFirebaseReference(.Users).whereField(K.UsersFStore.userIdField , isEqualTo: userId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let user = User(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(user)
        } else {
            completion(nil)
        }
    }

}

func updateCurrentUserInFirestore(withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
        getFirebaseReference(.Users).document(Auth.auth().currentUser!.uid).updateData(withValues) { (error) in
            
            completion(error)
            
            if error == nil {// then no error so the user object updated in firestore so can save it in UserDefaults
                //saveUserLocally(mUserDictionary: userObject)
                print("update done")
            }
        }
    
}
//MARK: - Basket
//func saveBasketToFirestore(_ basket: Basket) {
//    // .collection("rooms").document("roomA")
//    //.collection("messages").document("message1")
//
//    getFirebaseReference(.Baskets).document(basket.basketId).setData([K.BasketFStore.basketIdField :basket.basketId , K.BasketFStore.ownerIdField : basket.ownerId ,  K.BasketFStore.orderItemsIds : basket.orderItemsIds ]) { (error) in
//        if let e = error {
//            print("there is an error in saving data to fireStore \(e)")
//        }else {
//            print("successifly saving data to fireStore")
//        }
//    }}

func saveBasketToFirestore(_ basket: Basket) {
   
    getFirebaseReference(.Baskets).document(basket.basketId).setData([K.BasketFStore.basketIdField :basket.basketId , K.BasketFStore.ownerIdField : basket.ownerId ,  K.BasketFStore.orderItemsIds : basket.orderItemsIds ,  K.BasketFStore.orderBooksIds : basket.orderBooksIds ,  K.BasketFStore.orderNovelsIds : basket.orderNovelsIds]) { (error) in
        if let e = error {
            print("there is an error in saving data to fireStore \(e)")
        }else {
            print("successifly saving data to fireStore")
        }
    }}

func updateBasketInFirestore(_ basket: Basket, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    getFirebaseReference(.Baskets).document(basket.basketId).updateData(withValues) { (error) in
        completion(error)
    }
}
//MARK: - Download items
func downloadBasketFromFirestore(_ ownerId: String, completion: @escaping (_ basket: Basket?)-> Void) {
    
    getFirebaseReference(.Baskets).whereField(K.BasketFStore.ownerIdField , isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        } else {
            completion(nil)
        }
    }
}
//MARK: Download items for specific basket Func
func downloadBooksForSpecificBasket (_ withIds: [String], completion: @escaping (_ bookArray: [Book]) ->Void) {
    
    var count = 0
    var bookArr: [Book] = []
    
    if withIds.count > 0 {
        
        for itemId in withIds {
            getFirebaseReference(.Books).document(itemId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    completion(bookArr)
                    return
                }

                if snapshot.exists {

                    bookArr.append(Book(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                }
                
                if count == withIds.count {
                    completion(bookArr)
                }
                
            }
        }
    } else {
        completion(bookArr)
    }
}

func downloadNovelsForSpecificBasket (_ withIds: [String], completion: @escaping (_ novelArray: [Novel]) ->Void) {
    
    var count = 0
    var novelArr: [Novel] = []
    
    if withIds.count > 0 {
        
        for itemId in withIds {

            getFirebaseReference(.Novels).document(itemId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    completion(novelArr)
                    return
                }

                if snapshot.exists {

                    novelArr.append(Novel(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                }
                
                if count == withIds.count {
                    completion(novelArr)
                }
                
            }
        }
    } else {
        completion(novelArr)
    }
}
func downloadItemsForSpecificBasket (_ withIds: [String], completion: @escaping (_ itemArray: [Item]) ->Void) {
    
    var count = 0
    var itemArr: [Item] = []
    
    if withIds.count > 0 {
        
        for itemId in withIds {

            getFirebaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    completion(itemArr)
                    return
                }

                if snapshot.exists {

                    itemArr.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                }
                
                if count == withIds.count {
                    completion(itemArr)
                }
                
            }
        }
    } else {
        completion(itemArr)
    }
}
//MARK: Search
func downloadBooksForSearch (_ withIds: [String], completion: @escaping (_ bookArray: [Book]) ->Void) {
    
    var count = 0
    var bookArr: [Book] = []
    
    if withIds.count > 0 {
        
        for itemId in withIds {

            getFirebaseReference(.Books).document(itemId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    completion(bookArr)
                    return
                }

                if snapshot.exists {

                    bookArr.append(Book(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                }
                
                if count == withIds.count {
                    completion(bookArr)
                }
                
            }
        }
    } else {
        completion(bookArr)
    }
}

func downloadNovelsForSearch (_ withIds: [String], completion: @escaping (_ novelArray: [Novel]) ->Void) {
    
    var count = 0
    var novelArr: [Novel] = []
    
    if withIds.count > 0 {
        
        for itemId in withIds {

            getFirebaseReference(.Novels).document(itemId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    completion(novelArr)
                    return
                }

                if snapshot.exists {

                    novelArr.append(Novel(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                }
                
                if count == withIds.count {
                    completion(novelArr)
                }
                
            }
        }
    } else {
        completion(novelArr)
    }
}
func downloadItemsForSearch (_ withIds: [String], completion: @escaping (_ itemsArray: [Item]) ->Void) {
    
    var count = 0
    var itemArr: [Item] = []
    
    if withIds.count > 0 {
        
        for itemId in withIds {

            getFirebaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    completion(itemArr)
                    return
                }

                if snapshot.exists {

                    itemArr.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                }
                
                if count == withIds.count {
                    completion(itemArr)
                }
                
            }
        }
    } else {
        completion(itemArr)
    }
}
