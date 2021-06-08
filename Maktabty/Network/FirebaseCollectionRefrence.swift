//
//  FirebaseCollectionRefrence.swift
//  Maktabty
//
//  Created by Macbook on 09/05/2021.
//

import Foundation
import FirebaseFirestore
enum FCollectionRefrence : String {
    
    case Books
    case Novels
    case Items
    case Users
    case Baskets
}
func getFirebaseReference(_ collectionRefrence : FCollectionRefrence) -> CollectionReference {
    return Firestore.firestore().collection(collectionRefrence.rawValue)
}
