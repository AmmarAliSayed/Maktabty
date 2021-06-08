//
//  EditUserViewController.swift
//  Maktabty
//
//  Created by Macbook on 27/05/2021.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView
import FirebaseAuth

class EditUserViewController: UIViewController {
    //MARK: - IBOutlets
   
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    //MARK: - Vars
    
    var userImages: [UIImage?] = []
    var userImagesLinks: [String?] = []
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
     
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //put the activityIndicator in center of the screen
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1), padding: nil)
    }
//MARK: - IBActions
    @IBAction func choosePhotoButtonPressed(_ sender: Any) {
        //reset itemImages array before add new images for new item
        userImages = []
        showImageGallery()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        saveNewData()
    }
    
    //MARK: - Helper funcs
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    //check that all textFields Have Text or not empty
    private func textFieldsHaveText() -> Bool {
        return (emailTextField.text != "" && nameTextField.text != "" && phoneTextField.text != "")
    }
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Show Gallery
    private func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
    }
    //MARK: Activity Indicator
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }

    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }


    // UpdateUI
    private func loadUserInfo() {
        
        if Auth.auth().currentUser != nil {
            let userId = Auth.auth().currentUser?.uid
            retriveUserFromFirestore(userId: userId!) { (user) in
                self.nameTextField.text = user!.name
                self.emailTextField.text = user?.email
                self.phoneTextField.text = user?.phone
            }
        }
    }
    
    private func saveNewData(){
        showLoadingIndicator()
        if userImages.count > 0 {//then user add images
            uploadImages(images: userImages, itemId:Auth.auth().currentUser!.uid) { (imageLinkArray) in
                
                self.userImagesLinks = imageLinkArray
                self.updateCurrentUser()
                //go back
                self.hideLoadingIndicator()
                self.popTheView()
            }
          
    }else{
        self.updateCurrentUser()
        //go back
        self.hideLoadingIndicator()
        self.popTheView()
    }
}
    
    private func updateCurrentUser(){
            dismissKeyboard()
        
        if textFieldsHaveText() {
            let withValues = [K.UsersFStore.userNameField : nameTextField.text!, K.UsersFStore.emailField : emailTextField.text!, K.UsersFStore.phoneField : phoneTextField.text! ,K.UsersFStore.imageLinksField :userImagesLinks ] as [String : Any]
            
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                
                if error == nil {
                    self.hud.textLabel.text = "Updated!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                } else {
                    print("error updating user ", error!.localizedDescription)
                   self.hud.textLabel.text = error!.localizedDescription
                   self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                   self.hud.show(in: self.view)
                   self.hud.dismiss(afterDelay: 2.0)
                }
            }
            
        } else {
            hud.textLabel.text = "All fields are required!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            
        }
    }
    
}
//MARK: - GalleryControllerDelegate

extension EditUserViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            //convert the user selected images [resolvedImages] to uiImage type and then stored in itemImages array
            Image.resolve(images: images) { (resolvedImages) in
                
                self.userImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }

    
}

