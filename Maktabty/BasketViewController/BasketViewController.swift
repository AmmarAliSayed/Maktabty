//
//  BasketViewController.swift
//  Maktabty
//
//  Created by Macbook on 25/05/2021.
//

import UIKit
import FirebaseAuth
import JGProgressHUD
class BasketViewController: UIViewController {
//MARK: - IBOutlets
    @IBOutlet weak var numberOfItemsInBasketLabel: UILabel!
    @IBOutlet weak var totalPriceInBasketLabel: UILabel!
    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var checkOutButtonOutlet: UIButton!
    //MARK: - Vars
    var basketBooks:[Book] = []
    var basketNovels:[Novel] = []
    var basketItems:[Item] = []
    var basket: Basket?
    var basketTotalNumberOfItems = 0
    let hud = JGProgressHUD(style: .dark)
    //var orderedItemIds : [String] = []
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tabelView.dataSource = self
        tabelView.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        if Auth.auth().currentUser != nil {
            loadBasketFromFirestore()
        } else {
            self.updateTotalLabels(true)
        }
       
    }
//MARK: - IBActions
    @IBAction func checkOutButtonPressed(_ sender: Any) {
        
        if Auth.auth().currentUser != nil && basket != nil {
            self.emptyTheBasket()
            self.showNotification(text: "you will receive a message on your phone has all details about receiving the products", isError: false)
            
        } else {
            self.showNotification(text: "Please add items frist!", isError: true)
        }
    }
    //MARK: - Helper Functions
    //MARK: - Download basket
    private func loadBasketFromFirestore() {
        
        downloadBasketFromFirestore(Auth.auth().currentUser!.uid) { [self] (basket) in

            self.basket = basket
            self.getBasketBooks()
            self.getBasketNovels()
            self.getBasketItems()
        }
    }
    
    private func getBasketBooks() {
        
        if basket != nil && basket?.orderBooksIds != nil {
            
            downloadBooksForSpecificBasket(basket!.orderBooksIds) { (basketBooks) in

                self.basketBooks = basketBooks
                self.updateTotalLabels(false)
                self.tabelView.reloadData()
            }
        }
    }
    private func getBasketNovels() {
        
        if basket != nil && basket?.orderNovelsIds != nil {
            
            downloadNovelsForSpecificBasket(basket!.orderNovelsIds) { (basketNovels) in

                self.basketNovels = basketNovels
                self.updateTotalLabels(false)
                self.tabelView.reloadData()
            }
        }
    }
    private func getBasketItems() {
        
        if basket != nil && basket?.orderItemsIds != nil {
            
            downloadItemsForSpecificBasket(basket!.orderItemsIds) { (basketItems) in

                self.basketItems = basketItems
                self.updateTotalLabels(false)
                self.tabelView.reloadData()
            }
        }
    }
    
    private func returnBasketItemsNumber() -> Int{
       return  basketBooks.count + basketNovels.count +  basketItems.count
    }
    private func updateTotalLabels(_ isEmpty: Bool) {
        
        if isEmpty {
            numberOfItemsInBasketLabel.text = "Items in basket: 0"
            totalPriceInBasketLabel.text = "Total price: $\(returnBasketTotalPrice())"
        } else {
            numberOfItemsInBasketLabel.text = "Items in basket: \(returnBasketItemsNumber())"
            totalPriceInBasketLabel.text = "Total price: $\(returnBasketTotalPrice())"
        }
        
      checkoutButtonStatusUpdate()
    }
    private func returnBasketTotalPrice() -> Double {
        
        var totalPrice = 0.0
        
        for item in basketBooks {
            totalPrice += item.price
        }
        
        for item in basketNovels {
            totalPrice += item.price
        }
        
        for item in basketItems {
            totalPrice += item.price
        }
        return totalPrice
    }
    private func emptyTheBasket() {
        
        basketBooks.removeAll()
        basketNovels.removeAll()
        basketItems.removeAll()
        tabelView.reloadData()
        
        basket!.orderNovelsIds = []
        basket!.orderItemsIds = []
        basket!.orderBooksIds = []
        updateBasketInFirestore(basket!, withValues: [K.BasketFStore.orderBooksIds : basket!.orderBooksIds]) { (error) in
            
            if error != nil {
                print("Error updating basket ", error!.localizedDescription)
            }
            self.getBasketBooks()
            self.getBasketNovels()
            self.getBasketItems()
        }
        updateBasketInFirestore(basket!, withValues: [K.BasketFStore.orderNovelsIds : basket!.orderNovelsIds]) { (error) in
            
            if error != nil {
                print("Error updating basket ", error!.localizedDescription)
            }
            
            self.getBasketBooks()
            self.getBasketNovels()
            self.getBasketItems()
        }
        updateBasketInFirestore(basket!, withValues: [K.BasketFStore.orderItemsIds : basket!.orderItemsIds]) { (error) in
            
            if error != nil {
                print("Error updating basket ", error!.localizedDescription)
            }
            
            self.getBasketBooks()
            self.getBasketNovels()
            self.getBasketItems()
        }
    }
    //MARK: - Control checkoutButton
    
    private func checkoutButtonStatusUpdate() {
        
        checkOutButtonOutlet.isEnabled = basketBooks.count > 0 || basketNovels.count > 0 || basketItems.count > 0
        
        if checkOutButtonOutlet.isEnabled {
            checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1)
        } else {
            disableCheckoutButton()
        }
    }

    private func disableCheckoutButton() {
        checkOutButtonOutlet.isEnabled = false
        checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    private func showNotification(text: String, isError: Bool) {
        
        if isError {
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        } else {
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        
        self.hud.textLabel.text = text
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    private func removeBookFromBasket(itemId: String) {
        
        for i in 0..<basket!.orderBooksIds.count {
            
            if itemId == basket!.orderBooksIds[i] {
                basket!.orderBooksIds.remove(at: i)
                return
            }
        }
    }
    private func removeNovelFromBasket(itemId: String) {
        
        for i in 0..<basket!.orderNovelsIds.count {
            
            if itemId == basket!.orderNovelsIds[i] {
                basket!.orderNovelsIds.remove(at: i)
                return
            }
        }
    }
    private func removeItemFromBasket(itemId: String) {
        
        for i in 0..<basket!.orderItemsIds.count {
            
            if itemId == basket!.orderItemsIds[i] {
                basket!.orderItemsIds.remove(at: i)
                return
            }
        }
    }
}
extension BasketViewController : UITableViewDataSource ,UITableViewDelegate {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return basketBooks.count
        case 1:
            return basketNovels.count
        case 2:
            return basketItems.count
        default:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BasketBookNovelTableViewCell.self)) as? BasketBookNovelTableViewCell else {
                return UITableViewCell()
            }
            cell.bookNovelNameLabel.text = basketBooks[indexPath.row].bookName
            cell.bookNovelAutherLabel.text = basketBooks[indexPath.row].authorName
            cell.bookNovelPriceLabel.text = "$\(String(describing: basketBooks[indexPath.row].price!))"
            
            if basketBooks[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [basketBooks[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.bookNovelImageView.image = images.first as? UIImage
                    }
                }
            }
            
            cell.bookNovelView.layer.cornerRadius =  cell.bookNovelView.frame.height / 3
            cell.bookNovelImageView.layer.cornerRadius = cell.bookNovelImageView.frame.height / 3
            cell.bookNovelView.layer.borderWidth = 1
            cell.bookNovelView.layer.borderColor = #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BasketBookNovelTableViewCell.self)) as? BasketBookNovelTableViewCell else {
                return UITableViewCell()
            }
            cell.bookNovelNameLabel.text = basketNovels[indexPath.row].novelName
            cell.bookNovelAutherLabel.text = basketNovels[indexPath.row].authorName
            cell.bookNovelPriceLabel.text = "$\(String(describing: basketNovels[indexPath.row].price!))"
            
            if basketNovels[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [basketNovels[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.bookNovelImageView.image = images.first as? UIImage
                    }
                }
            }
            cell.bookNovelView.layer.cornerRadius =  cell.bookNovelView.frame.height / 3
            cell.bookNovelImageView.layer.cornerRadius = cell.bookNovelImageView.frame.height / 3
            cell.bookNovelView.layer.borderWidth = 1
            cell.bookNovelView.layer.borderColor = #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1)
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BasketItemsTableViewCell.self)) as? BasketItemsTableViewCell else {
                return UITableViewCell()
            }
            cell.itemNameLabel.text = basketItems[indexPath.row].itemName
            cell.itemPriceLabel.text = "$\(String(describing: basketItems[indexPath.row].price!))"
            
            if basketItems[indexPath.row].imageLinks.count > 0 {
                downloadImagesFromFirebase(imageUrls: [basketItems[indexPath.row].imageLinks.first!]) { (images) in
                    DispatchQueue.main.async {
                        cell.itemImageView.image = images.first as? UIImage
                    }
                }
            }
            cell.itemView.layer.cornerRadius =  cell.itemView.frame.height / 3
            cell.itemImageView.layer.cornerRadius = cell.itemImageView.frame.height / 3
            cell.itemView.layer.borderWidth = 1
            cell.itemView.layer.borderColor = #colorLiteral(red: 1, green: 0.431372549, blue: 0.631372549, alpha: 1)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var myTitle = ""
        switch (section) {
            case 0:
                myTitle = "books".localized
                break;
            case 1:
                myTitle = "novels".localized
                break;
            case 2:
                myTitle = "other items".localized
            break;
            default:
                break;
        }
        return  myTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 130
        case 1:
            return 130
        case 2:
            return 130
        default:
            return 130
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == .delete {
            
            switch indexPath.section {
            case 0:
                let bookToDelete = basketBooks[indexPath.row]
                basketBooks.remove(at: indexPath.row)
                tableView.reloadData()
                removeBookFromBasket(itemId: bookToDelete.id)
                
                updateBasketInFirestore(basket!, withValues: [K.BasketFStore.orderBooksIds : basket!.orderBooksIds])  { (error) in
                    
                    if error != nil {
                        print("error updating the basket", error!.localizedDescription)
                    }
                    // call getBasketItems() method because we deleted items and we need to get the latest items after deletion -> refresh items
                    self.getBasketBooks()
                    self.getBasketNovels()
                    self.getBasketItems()
                }
                
            case 1:
                let novelToDelete = basketNovels[indexPath.row]
                basketNovels.remove(at: indexPath.row)
                tableView.reloadData()
                removeNovelFromBasket(itemId: novelToDelete.id)
                
                updateBasketInFirestore(basket!, withValues: [K.BasketFStore.orderNovelsIds : basket!.orderNovelsIds]) { (error) in
                    
                    if error != nil {
                        print("Error updating basket ", error!.localizedDescription)
                    }
                    
                    self.getBasketBooks()
                    self.getBasketNovels()
                    self.getBasketItems()
                }
            case 2:
                 let itemToDelete = basketItems[indexPath.row]
                 basketItems.remove(at: indexPath.row)
                  tableView.reloadData()
                 removeItemFromBasket(itemId: itemToDelete.id)
        
                 updateBasketInFirestore(basket!, withValues: [K.BasketFStore.orderItemsIds : basket!.orderItemsIds]) { (error) in
                     
                     if error != nil {
                         print("Error updating basket ", error!.localizedDescription)
                     }
                     
                     self.getBasketBooks()
                     self.getBasketNovels()
                     self.getBasketItems()
                 }
            default:
                print("default")
            }
            
            
           
            
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    //hide section name if no data in cells
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if (section == 0 && basketBooks.isEmpty) {
//            return 0.0
//        }
//        return 0.0
//    }
    
}
