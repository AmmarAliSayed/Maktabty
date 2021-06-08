//
//  IntroViewController.swift
//  Maktabty
//
//  Created by Macbook on 05/05/2021.
//

import UIKit
import FirebaseAuth

class IntroViewController: UIViewController {
    //MARK:-> outlet
    
    @IBOutlet weak var introCollectionView: UICollectionView!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
   
  //  @IBOutlet weak var pageController: UIPageControl!
   // @IBOutlet weak var nextButtonOutlet: UIButton!
    
    //MARK:-> properties
    
    var onBoardSlide:[IntroDataModel] = []
    var currentPage = 0 {
        didSet {
            pageController.currentPage = currentPage
            if currentPage == onBoardSlide.count - 1 {
               //nextButtonOutlet.setTitle("Get Started", for: .normal)
                nextButtonOutlet.setTitle("get Started".localized, for: .normal)
            }
            else {
               // nextButtonOutlet.setTitle("Next", for: .normal)
                nextButtonOutlet.setTitle("Next".localized, for: .normal)
            }
        }
    }
    
    
    //MARK:-> life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetupCollectionView()
        assignValueToArray()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    //MARK:-> class Methods
    
    func assignValueToArray() {
        onBoardSlide = [
            IntroDataModel(title: "Amazing Books".localized, discreption: "get amazing books from all the wold.".localized, images: #imageLiteral(resourceName: "frist2")),
            IntroDataModel(title: "Amazing Novels".localized, discreption: "get amazing novels  for more than 10,000 auther.".localized, images:#imageLiteral(resourceName: "introImg2")),
            IntroDataModel(title: "Instant World-Wide Delivery".localized, discreption: "Your orders will be delivered instantly irrespective of your location around the world.".localized, images: #imageLiteral(resourceName: "introImg3"))
        ]
    }
    
    
    //MARK:-> IB Actions
    
    @IBAction func nextButtonTaped(_ sender: Any) {
        
       // UserDefaults.standard.set(true, forKey: "NewUser22")

        if currentPage == onBoardSlide.count - 1 {
          
            if Auth.auth().currentUser != nil {//then the user is loged in
                self.performSegue(withIdentifier: "toTabBarIdentifier", sender: nil)
            }else{
                self.performSegue(withIdentifier: "toWelcomeIdentifier", sender: nil)
            }
           
           // print("Go to Another Page 🚀")
        }
        
        else {
            currentPage += 1
            let indexpath = IndexPath(item: currentPage, section: 0)
            introCollectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
        }
        
    }
    

    

}

extension IntroViewController:UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func SetupCollectionView() {
        introCollectionView.delegate = self
        introCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardSlide.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = introCollectionView.dequeueReusableCell(withReuseIdentifier: IntroCollectionViewCell.idintfier, for: indexPath) as! IntroCollectionViewCell
        cell.ConfigureCell(onBoardSlide[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
