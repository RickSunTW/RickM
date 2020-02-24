//
//  ChatMessageCellCollectionViewCell.swift
//  RickM+
//
//  Created by RickSun on 2020/2/24.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit

class ChatMessageCellCollectionViewCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
//        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.init(name: "SAMPLE TEXT FOR NOW", size: 16)
//        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.red
        
//        clipsToBounds = true
        
//        let testView = UIView()
        
        self.addSubview(textView)
               
        textView.frame = CGRect(x: 10, y: 10, width: 200, height: 60)
//        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        textView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        textView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        textView.backgroundColor = UIColor.green
        textView.textColor = UIColor.black
        textView.text = "AMPLE TEXT FOR NOW"
        
    }
    
//    func setUp() {
        

//               textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//               textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//               textView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//               textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
 
    }
    
}
