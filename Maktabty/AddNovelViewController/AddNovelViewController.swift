//
//  AddNovelViewController.swift
//  Maktabty
//
//  Created by Macbook on 17/05/2021.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView
import Gallery

class AddNovelViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var numOfPagesTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var noOfCopiesTextField: UITextField!
    @IBOutlet weak var authorNameTextField: UITextField!
    @IBOutlet weak var novelNameTextField: UITextField!
    
    
    //MARK: - vars
    let pickerLanguage = UIPickerView()
    var toolBar = UIToolbar()
    let languagesArr = ["Arabic","English"]
    var currentIndex = 0
    var novelImages: [UIImage?] = []
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerLanguage.delegate = self
        pickerLanguage.dataSource = self
        //add toolBar to the PickerView
        toolBar.sizeToFit()
        let btnDone = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(closePicker))
        toolBar.setItems([btnDone], animated: true)
            
        languageTextField.inputView = pickerLanguage
        languageTextField.inputAccessoryView = toolBar
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //put the activityIndicator in center of the screen
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1), padding: nil)
    }
    //MARK: - IBActions
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
    
    @IBAction func chooseImageButtonPressed(_ sender: Any) {
        //reset itemImages array before add new images for new item
        novelImages = []
        showImageGallery()
    }
    
    //MARK: Helper functions
    
    private func dismissKeayboard() {
        self.view.endEditing(false)
    }
    //check from all fields not empty
    private func fieldsAreCompleted() -> Bool {
        
        return (languageTextField.text != "" && priceTextField.text != "" && numOfPagesTextField.text != "" && noOfCopiesTextField.text != "" && authorNameTextField.text != "" && novelNameTextField.text != "" )
    }
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc private func closePicker() {
        languageTextField.text = languagesArr[currentIndex]
        view.endEditing(true)
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
        let novelName = novelNameTextField.text!
        let authorName = authorNameTextField.text!
        let numberOfPages = Int(numOfPagesTextField.text!)
        let numberOfCopies = Int(noOfCopiesTextField.text!)
        let price =  Double(priceTextField.text!)
        let language = languageTextField.text!
       // var novel = Novel(id: id, novelName: novelName, authorName: authorName, numberOfCopies: numberOfCopies!, price: price!, numberOfPages: numberOfPages!, languge: language, imageLinks: [""])
        let novel = Novel()
        novel.id  = id
        novel.novelName = novelName
        novel.authorName = authorName
        novel.languge = language
        novel.imageLinks = []
        novel.numberOfCopies = numberOfCopies
        novel.numberOfPages = numberOfPages
        novel.price = price
        //saveBookToFirestore(book)
        if novelImages.count > 0 {//then user add images
            uploadImages(images: novelImages, itemId:novel.id) { (imageLinkArray) in
                
                novel.imageLinks = imageLinkArray
                
               saveNovelToFirestore(novel)
                //after save item in firestore we save it in Algolia too
                saveNovelToAlgolia(novel: novel)
              //  saveItemToAlgolia(item: item)
                self.hideLoadingIndicator()
                //go back after add the item
                self.popTheView()
            }
          
            
        } else {
            saveNovelToFirestore(novel)//then user don't add images so save item without images
            saveNovelToAlgolia(novel: novel)
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
//MARK: - UIPickerViewDelegate,UIPickerViewDataSource

extension AddNovelViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    //number of cols
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languagesArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languagesArr[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentIndex = row
        languageTextField.text = languagesArr[row]
    }
}

//MARK: - UITextFieldDelegate
extension AddNovelViewController : UITextFieldDelegate{
    //hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: - GalleryControllerDelegate

extension AddNovelViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            //convert the user selected images [resolvedImages] to uiImage type and then stored in itemImages array
            Image.resolve(images: images) { (resolvedImages) in
                
                self.novelImages = resolvedImages
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
