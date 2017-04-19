//
//  RSSCell.swift
//  BVInfoSwift
//
//  Created by Tyler Lafferty on 11/18/15.
//  Copyright © 2015 Tyler Lafferty. All rights reserved.
//

import Foundation
import UIKit

class RSSCell : UITableViewCell {
    
    @IBOutlet var titleLbl : UILabel!
    @IBOutlet var dateLbl : UILabel!
    
    override func awakeFromNib() {
        layer.cornerRadius = 3
//        backgroundColor = ThemeManager.colorForKey(colorStr: "mainCell")
//        titleLbl.textColor = ThemeManager.colorForKey(colorStr: "mainColor")
//        dateLbl.textColor = ThemeManager.colorForKey(colorStr: "mainColor")
    }
    
    func setupCell(blogPost : RSSPost) {
        titleLbl.text = blogPost.postTitle
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        let date = dateFormatter.date(from: blogPost.postDate)
        let shortDate = DateFormatter()
        shortDate.dateStyle = .medium
        shortDate.timeStyle = .none
        dateLbl.text = "\(shortDate.string(from: date!))"
        titleLbl.adjustsFontSizeToFitWidth = true
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            let mainWidth = UIScreen.main.bounds.width
            if frame.width > mainWidth - 16 {
                frame.origin.y += 8
                frame.size.height -= 16
                frame.origin.x += 8
                frame.size.width -= 16
            }else {
                if frame.origin.x != 8 {
                    frame.origin.x += 8
                }
            }
            super.frame = frame
        }
    }
}
