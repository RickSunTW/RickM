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
        
        tv.text = "SAMPLE TEXT FOR NOW"
        
        tv.font = UIFont.boldSystemFont(ofSize: 16)
        
        tv.backgroundColor = UIColor.clear
        
        tv.textColor = .white
        

//        tv.font = UIFont.init(name: "SAMPLE TEXT FOR NOW", size: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 0/255, green: 137/255, blue: 249/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "PalauJellyfish")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 8 
        
        imageView.layer.masksToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        return imageView
        
    }()
    
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = UIColor.red
        
        clipsToBounds = true
        
        self.addSubview(bubbleView)
        self.addSubview(textView)
        self.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 50)
        bubbleViewLeftAnchor?.isActive = true
        
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
 
    }
    
}
