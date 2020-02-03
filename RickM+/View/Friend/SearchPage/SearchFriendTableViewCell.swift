//
//  SearchFriendTableViewCell.swift
//  RickM+
//
//  Created by RickSun on 2020/2/1.
//  Copyright © 2020 RickSun. All rights reserved.
//

import UIKit

class SearchFriendTableViewCell: UITableViewCell {
    @IBOutlet weak var searchFriendImage: UIImageView!
    @IBOutlet weak var searchFriendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
