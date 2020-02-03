//
//  GiftViewController.swift
//  RickM+
//
//  Created by RickSun on 2020/2/2.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit
import Foundation

class GiftViewController: UIViewController {
    
    @IBOutlet weak var giftImageCollectionView: UICollectionView!
    @IBOutlet weak var giftImagePageView: UIPageControl!
    
    var imageTest = [
        UIImage(named: "KohTaoSunset"),
        UIImage(named: "PalauJellyfish"),
        UIImage(named: "ThaiTemple")
    ]
    
    var timer = Timer()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giftImageCollectionView.delegate = self
        
        giftImageCollectionView.dataSource = self
        
        giftImageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        giftImagePageView.numberOfPages = imageTest.count
        
        giftImagePageView.currentPage = 0
        
//        DispatchQueue.main.async {
//            
//            self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
//            
//        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func changeImage() {
        
        if counter < imageTest.count {
            
            let index = IndexPath.init(item: counter, section: 0)
            
            self.giftImageCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            
            giftImagePageView.currentPage = counter
            
            counter += 1
            
        } else {
            
            counter = 0
            
            let index = IndexPath.init(item: counter, section: 0)
            
            self.giftImageCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            
            giftImagePageView.currentPage = counter
            
            counter = 1
            
        }
    }
    
}

extension GiftViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageTest.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let withReuseIdentifier = "GiftImageCollectionView" {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftImageCollectionView", for: indexPath) as? GiftImageCollectionViewCell else {
                
                return UICollectionViewCell()
            }
            
            cell.giftSliderImageView.image = imageTest[indexPath.row]
            
            return cell
            
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = giftImageCollectionView.frame.size
        
        return CGSize(width: size.width, height: size.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
        
    }
}

