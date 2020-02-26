//
//  ChatLogMessageDataModel.swift
//  RickM+
//
//  Created by RickSun on 2020/2/20.
//  Copyright © 2020 RickSun. All rights reserved.
//

import Foundation
import UIKit


struct Message: Codable {
    var formid: String?
    var text: String?
    var toid: String?
    var timestamp: Double?
    var toName: String?
    var toPhotoUrl: URL?
    var timestampString: String?
    var chatUid: String?
    var imageUrl: URL?
    
}
