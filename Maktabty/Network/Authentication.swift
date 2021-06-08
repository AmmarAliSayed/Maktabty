//
//  Authentication.swift
//  Maktabty
//
//  Created by Macbook on 19/05/2021.
//

import Foundation
import FirebaseAuth

//MARK: - Register user

func registerUserWith(email: String, password: String,userName :String,phone :String,completion: @escaping (_ error: Error?) ->Void) {
    
    Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
        
        completion(error)
        
        if error == nil {
            // save user information as name, email, in UserDefaults
          //  saveUserDataToUserDefaults(userName: userName, email: email)
           // let user = User(userId: (authDataResult?.user.uid)!, email: email, phone: phone, name: userName, imageLink: "", orderItemsIds: [])
            let user  = User()
            user.userId = authDataResult?.user.uid
            user.email = email
            user.name = userName
            user.phone = phone
            user.imageLinks = []
            saveUserToFirestore(user: user)
        }
    }
}
//MARK: - Login func

 func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
    
    Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
        
        if error == nil {
           completion(error)
            
        } else {
            completion(error)
        }
    }
}


 func logOutCurrentUser(completion: @escaping (_ error: Error?) -> Void) {
    //signOut() func throws error so use do catch
    do {
        try Auth.auth().signOut()
        //after sign Out the user remove it from UserDefaults
      //  UserDefaults.standard.removeObject(forKey: K.UserDefaultsData.userName)
      //  UserDefaults.standard.removeObject(forKey:  K.UserDefaultsData.email)
      //  UserDefaults.standard.synchronize()
        completion(nil)

    } catch let error as NSError {
        completion(error)
    }
    
    
}
//func saveUserDataToUserDefaults(userName: String, email: String){
//        
//    UserDefaults.standard.setValue(userName, forKey: K.UserDefaultsData.userName)
//    UserDefaults.standard.setValue(email, forKey: K.UserDefaultsData.email)
//    
//}
