//
//  NovelDetailsViewController.swift
//  Maktabty
//
//  Created by Macbook on 17/05/2021.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class NovelDetailsViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var autherNameLabel: UILabel!
    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var langaugeLabel: UILabel!
    @IBOutlet weak var pagesNumberLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var novelNameLabel: UILabel!
    @IBOutlet weak var novelImageView: UIImageView!
    
    @IBOutlet weak var addToBasketButtonOutlet: UIButton!
    
    //MARK: - Vars
    var novel :Novel?
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
                    basket!.orderNovelsIds.append(self.novel!.id)
                    self.updateBasket(basket: basket!, withValues: [ K.BasketFStore.orderNovelsIds  : basket!.orderNovelsIds])
                }
            }
        }
    }
    
    //MARK: - Helper Functions
    
    func setData(){
        
        if let  novelName = novel?.novelName {
            novelNameLabel.text = novelName
        }
       
        if let authorName = novel?.authorName {
            autherNameLabel.text = "by. \(authorName)"
        }
        
        if let langauge = novel?.languge {
            langaugeLabel.text = langauge
        }
        
        if let pagesNumber = novel?.numberOfPages {
            pagesNumberLabel.text = "\(pagesNumber)"
        }
        
        if let price = novel?.price {
            priceLabel.text =  "\(price)"
        }
       
//        bookImageView.image = UIImage(named: (book?.imageLinks.first)!)
        if let imagesNumber = novel?.imageLinks.count{
            if imagesNumber > 0{
                downloadImagesFromFirebase(imageUrls: [novel!.imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        self.novelImageView.image = images.first as? UIImage
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
        if let  novelId = novel?.id  {
            newBasket.orderNovelsIds  = [novelId]
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
