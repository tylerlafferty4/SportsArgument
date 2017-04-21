//
//  Photo.swift
//  ChatChat
//
//  Created by Tyler Lafferty on 4/21/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class Photo {
    
    var user: String! = ""
    var photoUrl: String!
    
    init(user : String, photoUrl : String) {
        self.user = user
        self.photoUrl = photoUrl
    }

}
