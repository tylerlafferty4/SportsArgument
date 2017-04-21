//
//  PhotoWallViewController.swift
//  ChatChat
//
//  Created by Tyler Lafferty on 4/20/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class PhotoWallViewController : UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // -- Vars --
    var photoArray: [Photo] = []
    
    // -- Firebase Storage --
    var storage = FIRStorage.storage()
    var storageRef = FIRStorageReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(PhotoWallViewController.logout))
        self.navigationItem.rightBarButtonItem = logout
        
        let upload = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(PhotoWallViewController.choosePhoto))
        self.navigationItem.leftBarButtonItem = upload
        
        getPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func logout() {
        User.logOutUser { (true) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Requests
extension PhotoWallViewController {
    
    func getPhotos() {
        let dbRef = FIRDatabase.database().reference().child("images")
        dbRef.observe(.childAdded, with: { (snapshot) in
            // Get download URL from snapshot
            let downloadURL = snapshot.value as! String
            let username = snapshot.key.components(separatedBy: "-")
            // Create a storage reference from the URL
            let photo = Photo(user: username.first!, photoUrl: downloadURL)
            
            self.photoArray.insert(photo, at: 0)
            self.tableView.reloadData()
        })
    }
}

// MARK: - TableView Delegate
extension PhotoWallViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 520
    }
    
}

// MARK: - TableView Datasource
extension PhotoWallViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.photoArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! PhotoWallCell
        let photo = self.photoArray[indexPath.row]
        cell.setupCell(photo: photo)
        return cell
    }
}

// MARK: - Helpers
extension PhotoWallViewController {
    
    func choosePhoto() {
        self.performSegue(withIdentifier: "uploadPhoto", sender: self)
    }
}













