//
//  TwitterTimelineViewController.swift
//  ChatChat
//
//  Created by Tyler Lafferty on 4/17/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

class TwitterTimelineViewController : TWTRTimelineViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(TwitterTimelineViewController.logout))
        self.navigationItem.rightBarButtonItem = logout
        
        let client = TWTRAPIClient()
        
        // Set the Twitter Datasource to Sports Argument Twitter handle
        self.dataSource = TWTRUserTimelineDataSource(screenName: "sportsargue101", apiClient: client)
        
        // Use the Dark Theme
        TWTRTweetView.appearance().theme = .dark
        
        // Allow users to favorite tweets
        self.showTweetActions = true
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
