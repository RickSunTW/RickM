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
    @IBOutlet weak var giftProductItemCollectionView: UICollectionView!
    @IBOutlet weak var giftProductListTableView: UITableView!
    
    var imageTest = [
        UIImage(named: "KohTaoSunset"),
        UIImage(named: "PalauJellyfish"),
        UIImage(named: "ThaiTemple")
    ]
    
    var giftProductItemLabel = ["鼠年必備", "填飽肚子", "解饞零嘴", "來一杯吧", "甜食來襲", "解渴救星"]
    var product0 = ["哈根達斯迷你杯", "紅包袋", "義美小泡芙隨手包", "午後時光重乳奶茶"]
    var product1 = ["茶葉蛋", "全家39元早餐", "維力雜醬麵"]
    var product2 = ["可樂果", "乖乖奶油椰子", "統一大布丁"]
    var product3 = ["Let's Cafe 大杯熱拿鐵", "Let's Cafe 中杯熱巧克力", "Let's Cafe 50元兌換卷", "Let's Cafe 大杯冰拿鐵"]
    var product4 = ["易口舒脆皮軟新薄荷糖", "蓋奇巧克力棒", "金沙巧克力3粒裝", "森永牛奶糖", "曼陀珠20元系列"]
    var product5 = ["義美錫蘭紅茶", "FMC蜂蜜水", "波蜜果菜汁", "生活泡沫綠茶"]
    var selectedStatus = [Bool](repeating: false, count: 6)
    
    var timer = Timer()
    var counter = 0
    
    var selectItem: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        giftImageCollectionView.delegate = self
        
        giftImageCollectionView.dataSource = self
        
        giftProductItemCollectionView.delegate = self
        
        giftProductItemCollectionView.dataSource = self
        
        giftProductListTableView.delegate = self
        
        giftProductListTableView.dataSource = self
        
        giftProductListTableView.separatorStyle = .none
        
        giftImageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        giftImagePageView.numberOfPages = imageTest.count
        
        giftImagePageView.currentPage = 0
        
        DispatchQueue.main.async {
            
            self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            
        }
        selectedStatus[0] = true
         
        // Do any additional setup after loading the view.
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.giftProductItemCollectionView.reloadData()
//    }
    
    
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
        if collectionView == self.giftImageCollectionView {
            
            return imageTest.count
            
        }
        else if collectionView == self.giftProductItemCollectionView {
            
            return giftProductItemLabel.count
            
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.giftImageCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftImageCollectionView", for: indexPath) as? GiftImageCollectionViewCell else {
                
                return UICollectionViewCell()
            }
            
            cell.giftSliderImageView.image = imageTest[indexPath.row]
            
            return cell
            
        }
        else if collectionView == self.giftProductItemCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductItemsCollectionView", for: indexPath) as? ProductItemsCollectionViewCell else {
                
                return UICollectionViewCell()
            }
            
            cell.giftProductItemsLable.text = giftProductItemLabel[indexPath.row]
            cell.giftProductItemsLable.layer.borderWidth = 0.5
            cell.giftProductItemsLable.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            if (indexPath.row == 0) {
//                cell.contentView.backgroundColor =  UIColor.darkGray
//                self.selectedStatus[0] = true
//            }
            
            if selectedStatus[indexPath.item] {
                
                cell.contentView.backgroundColor = UIColor.darkGray
                
            } else {
                
                cell.contentView.backgroundColor = UIColor.lightGray
                
            }
            
            return cell
    
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.giftImageCollectionView {
            
            let size = giftImageCollectionView.frame.size
            
            return CGSize(width: size.width, height: size.height)
            
        }
        else if collectionView == self.giftProductItemCollectionView {
            
            let size = giftProductItemCollectionView.frame.size
            
            return CGSize(width: 90, height: size.height)
            
        }
        return CGSize(width: 100, height: 60)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.giftProductItemCollectionView {
                         
            selectItem = indexPath.row
            
            selectedStatus = [Bool](repeating: false, count: selectedStatus.count)
            
            selectedStatus[indexPath.row] = true

            self.giftProductItemCollectionView.reloadData()
            
            self.giftProductListTableView.reloadData()
            
        }
    }
}

extension GiftViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectItem {
            
        case 0: return product0.count
        case 1: return product1.count
        case 2: return product2.count
        case 3: return product3.count
        case 4: return product4.count
        case 5: return product5.count
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GiftProductListTableViewCell", for: indexPath) as? GiftProductListTableViewCell else {
            
            return UITableViewCell()
           
        }
        switch selectItem {
        case 0:
            cell.giftProductListName.text = product0[indexPath.row]
            cell.giftProductPrice.text = "$ 30"
            return cell
        case 1:
            cell.giftProductListName.text = product1[indexPath.row]
            cell.giftProductPrice.text = "$ 5"
            return cell
        case 2:
            cell.giftProductListName.text = product2[indexPath.row]
            cell.giftProductPrice.text = "$ 15"
            return cell
        case 3:
            cell.giftProductListName.text = product3[indexPath.row]
            cell.giftProductPrice.text = "$ 45"
            return cell
        case 4:
            cell.giftProductListName.text = product4[indexPath.row]
            cell.giftProductPrice.text = "$ 10"
            return cell
        case 5:
            cell.giftProductListName.text = product5[indexPath.row]
            cell.giftProductPrice.text = "$ 20"
            return cell
        default: return cell
        }
        
    }
    

}
