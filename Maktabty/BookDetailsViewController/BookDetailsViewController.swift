//
//  BookDetailsViewController.swift
//  Maktabty
//
//  Created by Macbook on 16/05/2021.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class BookDetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var autherNameLabel: UILabel!
    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var langaugeLabel: UILabel!
    @IBOutlet weak var pagesNumberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var addToBasketButtonOutlet: UIButton!
    
  //  @IBOutlet weak var addToCartButton: UIButton!
    //MARK: - Vars
    var book :Book?
    let hud = JGProgressHUD(style: .dark)
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //make stack view rounded 
         myStackView.layer.cornerRadius = 10
        disableAddBookButton()
    }
    //MARK: - IBActions
    @IBAction func addToBasketButtonPressed(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            //createNewBasket()
            downloadBasketFromFirestore(Auth.auth().currentUser!.uid) { (basket) in

                if basket == nil {
                    self.createNewBasket()
                } else {
                    basket!.orderBooksIds.append(self.book!.id)
                    self.updateBasket(basket: basket!, withValues: [ K.BasketFStore.orderBooksIds  : basket!.orderBooksIds])
                }
            }
        }else{
            //
        }
        
    }
    //MARK: - Helper Functions
    
    func setData(){
        
        if let  bookName = book?.bookName {
            bookNameLabel.text = bookName
        }
       
        if let authorName = book?.authorName {
            autherNameLabel.text = "by. \(authorName)"
        }
        
        if let langauge = book?.languge {
            langaugeLabel.text = langauge
        }
        
        if let pagesNumber = book?.numberOfPages {
            pagesNumberLabel.text = "\(pagesNumber)"
        }
        
        if let price = book?.price {
            priceLabel.text =  "\(price)"
        }
       
//        bookImageView.image = UIImage(named: (book?.imageLinks.first)!)
        if let imagesNumber = book?.imageLinks.count{
            if imagesNumber > 0{
                downloadImagesFromFirebase(imageUrls: [book!.imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        self.bookImageView.image = images.first as? UIImage
                    }
                }
            }
            
        }
    }
    
    //MARK: - Add to basket
    //if user has no basket ,create basket for him
    private func createNewBasket() {
        
        let id = UUID().uuidString
        let curruntUserId = Auth.auth().currentUser!.uid
       
        
      //  var itemIds = [self.book.id]
        let newBasket = Basket()
       // let newBasket = Basket(basketId: id, ownerId: curruntUserId, orderItemsIds: itemIds)
        newBasket.basketId = id
        newBasket.ownerId = curruntUserId
        if let  bookId = book?.id  {
            newBasket.orderBooksIds  = [bookId]
        }
       // newBasket.ownerId = "1234"
       
        saveBasketToFirestore(newBasket)
        
        self.hud.textLabel.text = "Added to basket!"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    //if user has allready a basket ,update basket for him
    private func updateBasket(basket: Basket, withValues: [String : Any]) {
        
        updateBasketInFirestore(basket, withValues: withValues) { (error) in
            //if  an error happend
            if error != nil {
                
                self.hud.textLabel.text = "Error: \(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)

                print("error updating basket", error!.localizedDescription)
            } else {
                
                self.hud.textLabel.text = "Added to basket!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    private func disableAddBookButton(){
        if Auth.auth().currentUser != nil {
            addToBasketButtonOutlet.isEnabled = true
        }else{
            addToBasketButtonOutlet.isEnabled = false
        }
    }
}

