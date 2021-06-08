//
//  AddItemViewController.swift
//  Maktabty
//
//  Created by Macbook on 18/05/2021.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {
    //MARK: - IBOutlets
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var noOfCopiesTextField: UITextField!
    @IBOutlet weak var itemNameTextField: UITextField!
   
    
    //MARK: - vars
    
    var itemImages: [UIImage?] = []
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //put the activityIndicator in center of the screen
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1), padding: nil)
    }

    //MARK: - IBActions
    @IBAction func chooseImageButtonPressed(_ sender: Any) {
        //reset itemImages array before add new images for new item
        itemImages = []
        showImageGallery()
    }
    

    @IBAction func doneButtonPressed(_ sender: Any) {
        
        dismissKeayboard()
        if fieldsAreCompleted() {
          //print("saving operation done")
            saveToFirestore()
        } else {
            //print("enter all data to fileds")
            self.hud.textLabel.text = "All fields are required!".localized
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
    }
    
    //MARK: Helper functions
    
    private func dismissKeayboard() {
        self.view.endEditing(false)
    }
    //check from all fields not empty
    private func fieldsAreCompleted() -> Bool {
        
        return ( priceTextField.text != "" && noOfCopiesTextField.text != "" && itemNameTextField.text != ""  )
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
    
    //MARK: - save book to firebase
    func saveToFirestore(){
        showLoadingIndicator()
        let id = UUID().uuidString
        let itemName = itemNameTextField.text!
        let numberOfCopies = Int(noOfCopiesTextField.text!)
        let price =  Double(priceTextField.text!)
       // var item = Item(id: id, itemName: itemName,numberOfCopies: numberOfCopies!, price: price!,  imageLinks: [""])
        //saveBookToFirestore(book)
        var item = Item()
        item.id  = id
        item.itemName = itemName
        item.imageLinks = []
        item.numberOfCopies = numberOfCopies
        item.price = price
        if itemImages.count > 0 {//then user add images
            uploadImages(images: itemImages, itemId:item.id) { (imageLinkArray) in
                
                item.imageLinks = imageLinkArray
                
               saveItemToFirestore(item)
                //after save item in firestore we save it in Algolia too
                saveItemToAlgolia(item: item)
                self.hideLoadingIndicator()
                //go back after add the item
                self.popTheView()
            }
        } else {
            saveItemToFirestore(item)//then user don't add images so save item without images
            saveItemToAlgolia(item: item)
            //go back after add the item
            popTheView()
        }
        
        
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
}

//MARK: - UITextFieldDelegate
extension AddItemViewController : UITextFieldDelegate{
    //hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: - GalleryControllerDelegate

extension AddItemViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            //convert the user selected images [resolvedImages] to uiImage type and then stored in itemImages array
            Image.resolve(images: images) { (resolvedImages) in
                
                self.itemImages = resolvedImages
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
