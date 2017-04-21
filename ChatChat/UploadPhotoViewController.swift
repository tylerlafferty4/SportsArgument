//
//  UploadPhotoViewController.swift
//  ChatChat
//
//  Created by Tyler Lafferty on 4/21/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CRNetworkButton

class UploadPhotoViewController : UIViewController {
    
    // -- Outlets --
    @IBOutlet var selectedImgView: UIImageView!
    @IBOutlet var uploadBtn: CRNetworkButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
