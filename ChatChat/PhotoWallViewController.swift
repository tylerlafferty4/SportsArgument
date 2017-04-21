//
//  PhotoWallViewController.swift
//  ChatChat
//
//  Created by Tyler Lafferty on 4/20/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class PhotoWallViewController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // -- Vars --
    var photoArray: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Requests
extension PhotoWallViewController {
    
    func getPhotos() {
        
    }
}

// MARK: - TableView Delegate
extension PhotoWallViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

// MARK: - TableView Datasource
extension PhotoWallViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.photoArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoWallCell
        let photo = self.photoArray[indexPath.row]
        cell.setupCell(photo: photo)
        return cell
    }
}













