//
//  ItemDetailsViewController.swift
//  Maktabty
//
//  Created by Macbook on 18/05/2021.
//

import UIKit
import JGProgressHUD
import FirebaseAuth
class ItemDetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var numberOfCopiesLabel: UILabel!

    @IBOutlet weak var addToBasketButtonOutlet: UIButton!
    //MARK: - Vars
    var item :Item?
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
    @IBAction func addToCartButtonPressed(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            //createNewBasket()
            downloadBasketFromFirestore(Auth.auth().currentUser!.uid) { (basket) in

                if basket == nil {
                    self.createNewBasket()
                } else {
                    basket!.orderItemsIds.append(self.item!.id)
                    self.updateBasket(basket: basket!, withValues: [ K.BasketFStore.orderItemsIds  : basket!.orderItemsIds])
                }
            }
        }
    }
    
    //MARK: - Helper Functions
    
    func setData(){
        
        if let  itemName = item?.itemName {
            itemNameLabel.text = itemName
        }
    
        if let price = item?.price {
            priceLabel.text =  "\(price)"
        }
        if let numberOfCopies = item?.numberOfCopies {
            numberOfCopiesLabel.text =  "\(numberOfCopies)"
        }
//        bookImageView.image = UIImage(named: (book?.imageLinks.first)!)
        if let imagesNumber = item?.imageLinks.count{
            if imagesNumber > 0{
                downloadImagesFromFirebase(imageUrls: [item!.imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        self.itemImageView.image = images.first as? UIImage
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
        if let  itemId = item?.id  {
            newBasket.orderItemsIds  = [itemId]
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
