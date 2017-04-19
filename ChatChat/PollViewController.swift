//
//  PollViewController.swift
//  ChatChat
//
//  Created by Tyler Lafferty on 4/18/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import SwiftSpinner

class PollViewController : UIViewController {
    
    // -- Outlets --
    @IBOutlet var pollStack: UIStackView!
    // Question
    @IBOutlet var questionLbl: UILabel!
    var question = ""
    // Option1
    @IBOutlet var option1View: UIView!
    @IBOutlet var option1Lbl: UILabel!
    @IBOutlet var option1VotesLbl: UILabel!
    @IBOutlet var option1ImgView: UIImageView!
    var option1 = ""
    var option1Votes = 0
    // Option2
    @IBOutlet var option2View: UIView!
    @IBOutlet var option2Lbl: UILabel!
    @IBOutlet var option2VotesLbl: UILabel!
    @IBOutlet var option2ImgView: UIImageView!
    var option2 = ""
    var option2Votes = 0
    // Option3
    @IBOutlet var option3View: UIView!
    @IBOutlet var option3Lbl: UILabel!
    @IBOutlet var option3VotesLbl: UILabel!
    @IBOutlet var option3ImgView: UIImageView!
    var option3 = ""
    var option3Votes = 0
    // Option4
    @IBOutlet var option4View: UIView!
    @IBOutlet var option4Lbl: UILabel!
    @IBOutlet var option4VotesLbl: UILabel!
    @IBOutlet var option4ImgView: UIImageView!
    var option4 = ""
    var option4Votes = 0
    // Option5
    @IBOutlet var option5View: UIView!
    @IBOutlet var option5Lbl: UILabel!
    @IBOutlet var option5VotesLbl: UILabel!
    @IBOutlet var option5ImgView: UIImageView!
    var option5 = ""
    var option5Votes = 0
    // Submit
    @IBOutlet var submitView: UIView!
    
    // -- Vars --
    var remoteConfig: FIRRemoteConfig!
    var optionSelected: Int!
    
    var pollRef: FIRDatabaseReference = FIRDatabase.database().reference().child("poll")
    var votesRef: FIRDatabaseReference = FIRDatabase.database().reference().child("poll/votes")
    
    var pollRefHandle: FIRDatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logout = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(PollViewController.logout))
        self.navigationItem.rightBarButtonItem = logout
        
        remoteConfig = FIRRemoteConfig.remoteConfig()
        
        
        if let _ = UserDefaults.standard.object(forKey: POLL_COMPLETE) {
        
        } else {
            SwiftSpinner.show("Setting up Poll")
            pollStack.isHidden = false
            setupPoll()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = UserDefaults.standard.object(forKey: POLL_COMPLETE) {
            SwiftSpinner.show("Loading Poll Results")
            hideImgViews()
            noInteration()
            unhideVoteLbls()
            getPollInformation()
        }
    }
    
    func logout() {
        User.logOutUser { (true) in
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Helpers
extension PollViewController {
    
    func displayPollResults() {
    
        pollRef.child("votes").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            self.option1Votes = value?["option1"] as? Int ?? 0
            self.option2Votes = value?["option2"] as? Int ?? 0
            self.option3Votes = value?["option3"] as? Int ?? 0
            self.option4Votes = value?["option4"] as? Int ?? 0
            self.option5Votes = value?["option5"] as? Int ?? 0
            
            self.showResultsUI()
        })
    }
    
    func getPollInformation() {
        remoteConfig = FIRRemoteConfig.remoteConfig()
        
        let expirationDuration = 3600
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
                self.question = self.remoteConfig.configValue(forKey: "Poll_Title").stringValue!
                self.option1 = self.remoteConfig.configValue(forKey: "Option1").stringValue!
                self.option2 = self.remoteConfig.configValue(forKey: "Option2").stringValue!
                self.option3 = self.remoteConfig.configValue(forKey: "Option3").stringValue!
                self.option4 = self.remoteConfig.configValue(forKey: "Option4").stringValue!
                self.option5 = self.remoteConfig.configValue(forKey: "Option5").stringValue!
                self.questionLbl.text = self.question
                self.option1Lbl.text = self.option1
                self.option2Lbl.text = self.option2
                self.option3Lbl.text = self.option3
                self.option4Lbl.text = self.option4
                self.option5Lbl.text = self.option5
                self.displayPollResults()
            } else {
                SwiftSpinner.hide()
                let alert = UIAlertController(title: "Sports Argument", message: "An error has occurred. Please try again later", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                print("Config not fetched")
                print("Error \(error!.localizedDescription)")
            }
        }
    }
    
    func setupPoll() {
        remoteConfig = FIRRemoteConfig.remoteConfig()
        #if DEBUG
            let expirationDuration = 0
            remoteConfig.configSettings = FIRRemoteConfigSettings(developerModeEnabled: true)
        #else
            let expirationDuration = 3600
        #endif
       
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
                self.question = self.remoteConfig.configValue(forKey: "Poll_Title").stringValue!
                self.option1 = self.remoteConfig.configValue(forKey: "Option1").stringValue!
                self.option2 = self.remoteConfig.configValue(forKey: "Option2").stringValue!
                self.option3 = self.remoteConfig.configValue(forKey: "Option3").stringValue!
                self.option4 = self.remoteConfig.configValue(forKey: "Option4").stringValue!
                self.option5 = self.remoteConfig.configValue(forKey: "Option5").stringValue!
                self.setupUI()
            } else {
                SwiftSpinner.hide()
                let alert = UIAlertController(title: "Sports Argument", message: "An error has occurred. Please try again later", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                print("Config not fetched")
                print("Error \(error!.localizedDescription)")
            }
        }
    }
}

// MARK: - UI 
extension PollViewController {
    
    func showResultsUI() {
        option1VotesLbl.text = "\(option1Votes)"
        option2VotesLbl.text = "\(option2Votes)"
        option3VotesLbl.text = "\(option3Votes)"
        option4VotesLbl.text = "\(option4Votes)"
        option5VotesLbl.text = "\(option5Votes)"
        SwiftSpinner.hide()
    }
    
    func setupUI() {
        questionLbl.text = question
        option1Lbl.text = option1
        option2Lbl.text = option2
        option3Lbl.text = option3
        option4Lbl.text = option4
        option5Lbl.text = option5
        addButtonActions()
    }
    
    func addButtonActions() {
        let option1Tap = UITapGestureRecognizer(target: self, action: #selector(PollViewController.option1Selected))
        option1View.addGestureRecognizer(option1Tap)
        
        let option2Tap = UITapGestureRecognizer(target: self, action: #selector(PollViewController.option2Selected))
        option2View.addGestureRecognizer(option2Tap)
        
        let option3Tap = UITapGestureRecognizer(target: self, action: #selector(PollViewController.option3Selected))
        option3View.addGestureRecognizer(option3Tap)
        
        let option4Tap = UITapGestureRecognizer(target: self, action: #selector(PollViewController.option4Selected))
        option4View.addGestureRecognizer(option4Tap)
        
        let option5Tap = UITapGestureRecognizer(target: self, action: #selector(PollViewController.option5Selected))
        option5View.addGestureRecognizer(option5Tap)
        
        let submitTap = UITapGestureRecognizer(target: self, action: #selector(PollViewController.submit))
        submitView.addGestureRecognizer(submitTap)
        
        SwiftSpinner.hide()
    }
    
    func updateImgViews() {
        if optionSelected == 1 {
            setImgViewChecked(imgView: option1ImgView)
            setImgViewUnchecked(imgView: option2ImgView)
            setImgViewUnchecked(imgView: option3ImgView)
            setImgViewUnchecked(imgView: option4ImgView)
            setImgViewUnchecked(imgView: option5ImgView)
            
        } else if optionSelected == 2 {
            setImgViewChecked(imgView: option2ImgView)
            setImgViewUnchecked(imgView: option1ImgView)
            setImgViewUnchecked(imgView: option3ImgView)
            setImgViewUnchecked(imgView: option4ImgView)
            setImgViewUnchecked(imgView: option5ImgView)
            
        } else if optionSelected == 3 {
            setImgViewChecked(imgView: option3ImgView)
            setImgViewUnchecked(imgView: option2ImgView)
            setImgViewUnchecked(imgView: option1ImgView)
            setImgViewUnchecked(imgView: option4ImgView)
            setImgViewUnchecked(imgView: option5ImgView)
            
        } else if optionSelected == 4 {
            setImgViewChecked(imgView: option4ImgView)
            setImgViewUnchecked(imgView: option2ImgView)
            setImgViewUnchecked(imgView: option3ImgView)
            setImgViewUnchecked(imgView: option1ImgView)
            setImgViewUnchecked(imgView: option5ImgView)
            
        } else if optionSelected == 5 {
            setImgViewChecked(imgView: option5ImgView)
            setImgViewUnchecked(imgView: option2ImgView)
            setImgViewUnchecked(imgView: option3ImgView)
            setImgViewUnchecked(imgView: option4ImgView)
            setImgViewUnchecked(imgView: option1ImgView)
        }
    }
    
    func noInteration() {
        option1View.isUserInteractionEnabled = false
        option2View.isUserInteractionEnabled = false
        option3View.isUserInteractionEnabled = false
        option4View.isUserInteractionEnabled = false
        option5View.isUserInteractionEnabled = false
    }
    
    func hideImgViews() {
        option1ImgView.isHidden = true
        option2ImgView.isHidden = true
        option3ImgView.isHidden = true
        option4ImgView.isHidden = true
        option5ImgView.isHidden = true
        submitView.isHidden = true
    }
    
    func unhideVoteLbls() {
        option1VotesLbl.isHidden = false
        option2VotesLbl.isHidden = false
        option3VotesLbl.isHidden = false
        option4VotesLbl.isHidden = false
        option5VotesLbl.isHidden = false
    }
    
    func setImgViewChecked(imgView : UIImageView) {
        imgView.image = UIImage(named: "checked")
    }
    
    func setImgViewUnchecked(imgView : UIImageView) {
        imgView.image = UIImage(named: "unchecked")
    }
}

// MARK: - Button Actions
extension PollViewController {
    
    func option1Selected() {
        optionSelected = 1
        updateImgViews()
    }
    
    func option2Selected() {
        optionSelected = 2
        updateImgViews()
    }
    
    func option3Selected() {
        optionSelected = 3
        updateImgViews()
    }
    
    func option4Selected() {
        optionSelected = 4
        updateImgViews()
    }
    
    func option5Selected() {
        optionSelected = 5
        updateImgViews()
    }
    
    func submit() {
        UserDefaults.standard.set(true, forKey: POLL_COMPLETE)
        
        pollRef.child("votes").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            if self.optionSelected == 1 {
                var votes = value?["option1"] as? Int ?? 0
                votes += 1
                self.pollRef.child("votes/option1").setValue(votes)
                self.displayPollResults()
            } else if self.optionSelected == 2 {
                var votes = value?["option2"] as? Int ?? 0
                votes += 1
                self.pollRef.child("votes/option2").setValue(votes)
                self.displayPollResults()
                
            } else if self.optionSelected == 3 {
                var votes = value?["option3"] as? Int ?? 0
                votes += 1
                self.pollRef.child("votes/option3").setValue(votes)
                self.displayPollResults()
                
            } else if self.optionSelected == 4 {
                var votes = value?["option4"] as? Int ?? 0
                votes += 1
                self.pollRef.child("votes/option4").setValue(votes)
                self.displayPollResults()
                
            } else if self.optionSelected == 5 {
                var votes = value?["option5"] as? Int ?? 0
                votes += 1
                self.pollRef.child("votes/option5").setValue(votes)
                self.displayPollResults()
                
            }
        })
    }
}










