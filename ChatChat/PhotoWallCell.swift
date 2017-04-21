//
//  PhotoWallCell.swift
//  ChatChat
//
//  Created by Tyler Lafferty on 4/20/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class PhotoWallCell : UITableViewCell {
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        
    }
    
    func setupCell(photo : Photo) {
        userNameLbl.text = photo.user
        
    }
}
