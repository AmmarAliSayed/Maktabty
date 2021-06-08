//
//  AlgoliaService.swift
//  Maktabty
//
//  Created by Macbook on 29/05/2021.
//

import Foundation
import InstantSearchClient //Algolia
class AlgoliaService {
    
    static let shared = AlgoliaService()
    
    let client = Client(appID: K.Algolia.APP_ID, apiKey: K.Algolia.ADMIN_KEY)
    let bookIndex = Client(appID: K.Algolia.APP_ID, apiKey:  K.Algolia.ADMIN_KEY).index(withName: "book_Name")
    let novelIndex = Client(appID: K.Algolia.APP_ID, apiKey:  K.Algolia.ADMIN_KEY).index(withName: "novel_name")
    let itemIndex = Client(appID: K.Algolia.APP_ID, apiKey:  K.Algolia.ADMIN_KEY).index(withName: "item_Name")
    private init() {}
    
    
}

//MARK: - Algolia Funcs
//when create new item in firestore we want also save it in Algolia
func saveBookToAlgolia(book: Book) {
    
    let index = AlgoliaService.shared.bookIndex
    
    let bookToSave = bookDictionaryFrom(book) as! [String : Any]
    
    index.addObject(bookToSave, withID: book.id, requestOptions: nil) { (content, error) in
        
        
        if error != nil {
            print("error saving to algolia", error!.localizedDescription)
        } else {
            print("added to algolia")
        }
    }
}

func searchBookInAlgolia(searchString: String, completion: @escaping (_ itemArray: [String]) -> Void) {

    let index = AlgoliaService.shared.bookIndex
    var resultIds: [String] = []
    
    let query = Query(query: searchString)
    
    query.attributesToRetrieve = ["bookName", "authorName"]
    
    index.search(query) { (content, error) in
        
        if error == nil {
            let cont = content!["hits"] as! [[String : Any]]
            
            resultIds = []
            
            for result in cont {
                resultIds.append(result["objectID"] as! String)
            }
            
            completion(resultIds)
        } else {
            print("Error algolia search ", error!.localizedDescription)
            completion(resultIds)
        }
    }
}

func saveNovelToAlgolia(novel: Novel) {
    
    let index = AlgoliaService.shared.novelIndex
    
    let bookToSave = novelDictionaryFrom(novel) as! [String : Any]
    
    index.addObject(bookToSave, withID: novel.id, requestOptions: nil) { (content, error) in
        
        
        if error != nil {
            print("error saving to algolia", error!.localizedDescription)
        } else {
            print("added to algolia")
        }
    }
}

func searchNovelInAlgolia(searchString: String, completion: @escaping (_ itemArray: [String]) -> Void) {

    let index = AlgoliaService.shared.novelIndex
    var resultIds: [String] = []
    
    let query = Query(query: searchString)
    
    query.attributesToRetrieve = ["novelName", "authorName"]
    
    index.search(query) { (content, error) in
        
        if error == nil {
            let cont = content!["hits"] as! [[String : Any]]
            
            resultIds = []
            
            for result in cont {
                resultIds.append(result["objectID"] as! String)
            }
            
            completion(resultIds)
        } else {
            print("Error algolia search ", error!.localizedDescription)
            completion(resultIds)
        }
    }
}

func saveItemToAlgolia(item: Item) {
    
    let index = AlgoliaService.shared.itemIndex
    
    let itemToSave = itemDictionaryFrom(item) as! [String : Any]
    
    index.addObject(itemToSave, withID: item.id, requestOptions: nil) { (content, error) in
        
        
        if error != nil {
            print("error saving to algolia", error!.localizedDescription)
        } else {
            print("added to algolia")
        }
    }
}

func searchItemInAlgolia(searchString: String, completion: @escaping (_ itemArray: [String]) -> Void) {

    let index = AlgoliaService.shared.itemIndex
    var resultIds: [String] = []
    
    let query = Query(query: searchString)
    
    query.attributesToRetrieve = ["itemName"]
    
    index.search(query) { (content, error) in
        
        if error == nil {
            let cont = content!["hits"] as! [[String : Any]]
            
            resultIds = []
            
            for result in cont {
                resultIds.append(result["objectID"] as! String)
            }
            
            completion(resultIds)
        } else {
            print("Error algolia search ", error!.localizedDescription)
            completion(resultIds)
        }
    }
}
