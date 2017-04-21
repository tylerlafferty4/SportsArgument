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
    
    // -- Firebase Storage --
    var storage = FIRStorage.storage()
    var storageRef = FIRStorageReference()
    var database = FIRDatabase()
    var imagesRef: FIRDatabaseReference = FIRDatabase.database().reference().child("images")
    
    // -- Vars --
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Upload"
        
        let logout = UIBarButtonItem(title: "Choose", style: .plain, target: self, action: #selector(UploadPhotoViewController.photoFromLibrary))
        self.navigationItem.rightBarButtonItem = logout
        
        picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Upload
extension UploadPhotoViewController {
    
    func photoFromLibrary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func uploadPhoto(sender: CRNetworkButton) {
        sender.startAnimate()
        
        // Add the image as an attachment
        if let imgData: Data = UIImagePNGRepresentation(selectedImgView.image!) {
            
            // Create an image name to use
            let imageName = getUniqueFileName()
            
            // Create a reference to the file you want to upload
            let imageRef = storageRef.child("images/" + imageName)
            
            // Upload the file
            let uploadTask = imageRef.put(imgData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print("******An Error Occurred******")
                    return
                }
                let downloadURL = metadata.downloadURL()?.absoluteString
                // Write the download URL to the Realtime Database
                let dbRef = FIRDatabase.database().reference().child("images/" + imageName)
                dbRef.setValue(downloadURL)
                // Metadata contains file metadata such as size, content-type, and download URL.
                //                let downloadURL = metadata.downloadURL
                sender.stopAnimate()
                
            }
            
            // Track the progress of the upload
            _ = uploadTask.observe(.progress) { snapshot in
                // A progress event occured
                print("Progress -> \(CGFloat(snapshot.progress!.completedUnitCount) / CGFloat(snapshot.progress!.totalUnitCount))")
                
                // Update the label with the percent complete
                let percentComplete = 100 * CGFloat(snapshot.progress!.completedUnitCount) / CGFloat(snapshot.progress!.totalUnitCount)
                let rounded = CGFloat(percentComplete.rounded())
                self.uploadBtn.updateProgress(100 * (CGFloat(snapshot.progress!.completedUnitCount) / CGFloat(snapshot.progress!.totalUnitCount)))
                
            }
        }

    }
}

// MARK: - ImagePicker Delegate
extension UploadPhotoViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        selectedImgView.contentMode = .scaleAspectFit //3
        selectedImgView.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Helpers
extension UploadPhotoViewController {
    
    /// Returns a unique file name for saving to Firebase
    func getUniqueFileName() -> String {
        let uuid = UUID().uuidString
        let fileName = "\(User.getUserName())-\(uuid)"
        return fileName
    }
    
    func addDownloadURLToFirebase(downloadUrl : URL) {
        
    }
}












