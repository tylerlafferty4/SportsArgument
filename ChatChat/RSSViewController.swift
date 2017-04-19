//
//  RSSViewController.swift
//  BVInfoSwift
//
//  Created by Tyler Lafferty on 11/16/15.
//  Copyright © 2015 Tyler Lafferty. All rights reserved.
//

import UIKit
//import GoogleMobileAds
import AudioToolbox

class RSSViewController: UIViewController, XMLParserDelegate {

    @IBOutlet var tableView : UITableView!
    var parser: XMLParser = XMLParser()
    var blogPosts : [RSSPost] = []
    var postTitle: String = String()
    var postLink: String = String()
    var postDate: String = String()
    var postDesc: String = String()
    var postContent: String = String()
    var eName: String = String()
    var rssUrl : String! = "http://www.sportsargument.com/feed/"
    var titleTxt : String! = ""
//    var adMobBannerView = GADBannerView()
    
    var shouldShowDescription = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        initAdMobBanner()
//        self.view.backgroundColor = ThemeManager.colorForKey(colorStr: "mainBackground")
//        self.tableView.backgroundColor = ThemeManager.colorForKey(colorStr: "mainBackground")
        
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(RSSViewController.logout))
        self.navigationItem.rightBarButtonItem = logout
        
        let url:URL = URL(string: rssUrl)!
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        
        parser.parse()
    }
    
    func logout() {
        User.logOutUser { (true) in
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        eName = elementName
        if elementName == "item" {
            postTitle = String()
            postLink = String()
            postDate = String()
            postContent = String()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (!data.isEmpty) {
            if eName == "title" {
                postTitle += data
            } else if eName == "link" {
                postLink += data
            } else if eName == "pubDate" {
                postDate += data
            } else if eName == "description" {
                postDesc += data
            } else if eName == "content:encoded" {
                postContent += data
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let blogPost: RSSPost = RSSPost()
            blogPost.postTitle = postTitle
            blogPost.postLink = postLink
            blogPost.postDate = postDate
            blogPost.postDesc = postDesc
            blogPost.postContent = postContent
            blogPosts.append(blogPost)
        }
    }
}

// MARK: - Table View Delegate
extension RSSViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if shouldShowDescription {
//            self.performSegue(withIdentifier: "viewpost", sender: self)
            self.tableView.deselectRow(at: indexPath, animated: false)
        } else {
//            self.performSegue(withIdentifier: "viewpost", sender: self)
            self.tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

// MARK: - Table View Datasource
extension RSSViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RSSCell
        let blogPost: RSSPost = blogPosts[indexPath.row]
        cell.setupCell(blogPost: blogPost)
        return cell
    }
}

// MARK: - Prepare for segue
extension RSSViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "viewpost" {

        }
    }
}

