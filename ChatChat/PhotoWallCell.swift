//
//  PhotoWallCell.swift
//  ChatChat
//
//  Created by Tyler Lafferty on 4/20/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class PhotoWallCell : UITableViewCell {
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    let progressIndicatorView = CircularLoaderView(frame: CGRect.zero)
    
    override func awakeFromNib() {
        
    }
    
    func setupCell(photo : Photo) {
        userNameLbl.text = photo.user
        
        imgView.addSubview(self.progressIndicatorView)
        progressIndicatorView.frame = bounds
        progressIndicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let imageUrl = URL(string: photo.photoUrl) {
            imgView.sd_setImage(with: imageUrl, placeholderImage: nil, options: .cacheMemoryOnly, progress: {
                [weak self]
                (receivedSize, expectedSize) -> Void in
                // Update progress here
                self!.progressIndicatorView.progress = CGFloat(receivedSize)/CGFloat(expectedSize)
            }) {
                [weak self]
                (image, error, _, _) -> Void in
                // Reveal image here
                self!.progressIndicatorView.reveal()
            }
        }

//        if photo.photoUrl != nil && photo.photoUrl.characters.count > 0 {
//            DispatchQueue.global(qos: .default).async(execute: {
//                if let imageUrl = URL(string: photo.photoUrl) {
//                    if let imageData = try? Data(contentsOf: imageUrl) {
//                        if let image = UIImage(data: imageData) {
//                            DispatchQueue.main.async(execute: { 
//                                self.imgView.image = image
//                            })
//                        }
//                    }
//                }
//            })
//        }
    }
}
