//
//  ScoringToolViewController.swift
//  ivolleyscore
//
//  Created by Terry Behrend on 2/11/16.
//  Copyright © 2016 jbapps. All rights reserved.
//

import UIKit

class ScoringToolViewController: UIViewController {
    
    var matchKey: String!
    
    var totalPossibleSets = 3
    var setsToWin = 2
    
    var pointsToWin = 25

    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    @IBOutlet weak var homeSetsLabel: UILabel!
    @IBOutlet weak var awaySetsLabel: UILabel!
    @IBOutlet weak var homeServingImg: UIImageView!
    @IBOutlet weak var awayServingImg: UIImageView!

    @IBOutlet weak var setsToWinButton: UIButton!
    @IBOutlet weak var playToButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        awayServingImg.hidden = true

        DataService.ds.REF_MATCHES.childByAppendingPath(matchKey).observeEventType(.Value, withBlock: {
            snapshot in
            
            if let score = snapshot.value as? Dictionary<String, AnyObject> {
                self.updateLabels(score)
            }
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateLabels(scoreboard: Dictionary<String, AnyObject>) {
        if let home = scoreboard["homeTeam"] as? String {
            homeTeamName.text = home
        }
        if let away = scoreboard["awayTeam"] as? String {
            awayTeamName.text = away
        }
        if let homeScore = scoreboard["homeScore"] as? Int {
            homeScoreLabel.text = String(homeScore)
        }
        if let awayScore = scoreboard["awayScore"] as? Int {
            awayScoreLabel.text = String(awayScore)
        }
        if let homeSets = scoreboard["homeSets"] as? Int {
            homeSetsLabel.text = String(homeSets)
        }
        if let awaySets = scoreboard["awaySets"] as? Int {
            awaySetsLabel.text = String(awaySets)
        }
        
    }
    
    @IBAction func addOneToHomeScore(sender: AnyObject) {
        
        guard let homeScoreText = homeScoreLabel.text else {
            return
        }
        guard let homeScoreInt = Int(homeScoreText) else {
            return
        }
        guard let homeSetsText = homeSetsLabel.text else {
            return
        }
        guard let homeSetsInt = Int(homeSetsText) else {
            return
        }
        
        homeScoreLabel.text = String(homeScoreInt + 1)
        homeServingImg.hidden = false
        awayServingImg.hidden = true
        DataService.ds.REF_MATCHES.childByAppendingPath(matchKey).childByAppendingPath("homeScore").setValue(homeScoreInt)
        DataService.ds.REF_MATCHES.childByAppendingPath(matchKey).childByAppendingPath("homeServing").setValue(true)
        DataService.ds.REF_MATCHES.childByAppendingPath(matchKey).childByAppendingPath("awayServing").setValue(false)
        
        if homeTeamWinner() {
            if homeSetsInt + 1 >= setsToWin {
                self.showMatchOverAlert("Match Over", msg: "Declare winner and end match?", winner: "home")
            }
            else {
                self.showGameOverAlert("Game Over", msg: "Declare winner, update sets, and start new game?", winner: "home")
                
            }
        }
        
    }
    
    @IBAction func subtractOneFromHomeScore(sender: AnyObject) {
        if Int(homeScoreLabel.text!)! > 0 {
            homeScoreLabel.text = String(Int(homeScoreLabel.text!)! - 1)
            DataService.ds.REF_MATCHES.childByAppendingPath(matchKey).childByAppendingPath("homeScore").setValue(Int(homeScoreLabel.text!)!)
        }
    }
    
    @IBAction func addOneToAwayScore(sender: AnyObject) {
        awayScoreLabel.text = String(Int(awayScoreLabel.text!)! + 1)
        homeServingImg.hidden = true
        awayServingImg.hidden = false
        DataService.ds.REF_MATCHES.childByAppendingPath(matchKey).childByAppendingPath("awayScore").setValue(Int(awayScoreLabel.text!)!)
        DataService.ds.REF_MATCHES.childByAppendingPath(matchKey).childByAppendingPath("awayServing").setValue(true)
        DataService.ds.REF_MATCHES.childByAppendingPath(matchKey).childByAppendingPath("homeServing").setValue(false)
        
        if awayTeamWinner() {
            if Int(awaySetsLabel.text!)! + 1 >= setsToWin {
                self.showMatchOverAlert("Match Over", msg: "Declare winner and end match?", winner: "away")
            }
            else {
                self.showGameOverAlert("Game Over", msg: "Declare winner, update sets, and start new game?", winner: "away")
            }
        }
    }
    
    @IBAction func subtractOneFromAwayScore(sender: AnyObject) {
        if Int(awayScoreLabel.text!)! > 0 {
            awayScoreLabel.text = String(Int(awayScoreLabel.text!)! - 1)
            DataService.ds.REF_MATCHES.childByAppendingPath(matchKey).childByAppendingPath("awayScore").setValue(Int(awayScoreLabel.text!)!)
        }
    }
    
    

    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showGameOverAlert(title: String, msg: String, winner: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
            action in
            
            if winner == "home" {
                self.homeSetsLabel.text = String(Int(self.homeSetsLabel.text!)! + 1)
            }
            else if winner == "away" {
                self.awaySetsLabel.text = String(Int(self.awaySetsLabel.text!)! + 1)
            }
            
            if (self.pointsToWin > 15 && Int(self.homeSetsLabel.text!)! + Int(self.awaySetsLabel.text!)! + 1 == self.totalPossibleSets) {
                self.pointsToWin = 15
                self.playToButton.setTitle("Play To: 15", forState: .Normal)
            }
            
            
            DataService.ds.REF_MATCHES.childByAppendingPath(self.matchKey).childByAppendingPath("homeSets").setValue(Int(self.homeSetsLabel.text!)!)
            DataService.ds.REF_MATCHES.childByAppendingPath(self.matchKey).childByAppendingPath("awaySets").setValue(Int(self.awaySetsLabel.text!)!)
            DataService.ds.REF_MATCHES.childByAppendingPath(self.matchKey).childByAppendingPath("homeScore").setValue(0)
            DataService.ds.REF_MATCHES.childByAppendingPath(self.matchKey).childByAppendingPath("awayScore").setValue(0)
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showMatchOverAlert(title: String, msg: String, winner: String) {
        // TODO:
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: {
            action in
            
            if winner == "home" {
                self.homeSetsLabel.text = String(Int(self.homeSetsLabel.text!)! + 1)
            }
            else if winner == "away" {
                self.awaySetsLabel.text = String(Int(self.awaySetsLabel.text!)! + 1)
            }
            
            DataService.ds.REF_MATCHES.childByAppendingPath(self.matchKey).childByAppendingPath("homeSets").setValue(Int(self.homeSetsLabel.text!)!)
            DataService.ds.REF_MATCHES.childByAppendingPath(self.matchKey).childByAppendingPath("awaySets").setValue(Int(self.awaySetsLabel.text!)!)
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func homeTeamWinner() -> Bool {
        
        if let homeScoreText = homeScoreLabel.text, let awayScoreText = awayScoreLabel.text {
            if let homeScore = Int(homeScoreText), let awayScore = Int(awayScoreText) {
                if (homeScore >= pointsToWin) && ((homeScore - awayScore) > 1) {
                    return true
                }
                return false
            }
            return false
        }
        return false
        
    }
    
    func awayTeamWinner() -> Bool {
        
//        if Int(awayScoreLabel.text!)! >= pointsToWin && (Int(awayScoreLabel.text!)! - Int(homeScoreLabel.text!)!) > 1 {
//            return true
//        }
//        return false
        
        if let homeScoreText = homeScoreLabel.text, let awayScoreText = awayScoreLabel.text {
            if let homeScore = Int(homeScoreText), let awayScore = Int(awayScoreText) {
                if (awayScore >= pointsToWin) && ((awayScore - homeScore) > 1) {
                    return true
                }
                return false
            }
            return false
        }
        return false
        
    }
    
    
    @IBAction func setsRequiredButton(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Games To Win", message: nil, preferredStyle: .ActionSheet)
        
        let action3 = UIAlertAction(title: "Best 3 out of 5", style: .Default, handler: {
        
            action3 in
            
            self.totalPossibleSets = 5
            self.setsToWin = 3
            self.setsToWinButton.setTitle("Best 3 out of 5", forState: .Normal)
            
        })
        
        let action2 = UIAlertAction(title: "Best 2 out of 3", style: .Default, handler: {
        
            action2 in
            
            self.totalPossibleSets = 3
            self.setsToWin = 2
            self.setsToWinButton.setTitle("Best 2 out of 3", forState: .Normal)
        
        })
        
        let action1 = UIAlertAction(title: "Single Game", style: .Default, handler: {
        
            action1 in
            
            self.totalPossibleSets = 1
            self.setsToWin = 1
            self.setsToWinButton.setTitle("Single Game", forState: .Normal)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        if Int(homeSetsLabel.text!)! < 3 && Int(awaySetsLabel.text!)! < 3 {
            alert.addAction(action3)
        }
        
        if Int(homeSetsLabel.text!)! < 2 && Int(awaySetsLabel.text!)! < 2 {
            alert.addAction(action2)
        }
        
        if Int(homeSetsLabel.text!)! < 1 && Int(awaySetsLabel.text!)! < 1 {
            alert.addAction(action1)
        }
        
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func playToButtonPressed(sender: UIButton) {
        
        let alert = UIAlertController(title: title, message: "Points to Win", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
            textField.placeholder = "Points needed to win this game"
            textField.keyboardType = UIKeyboardType.NumberPad
            
        }
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
        
            if let newPoints = alert.textFields![0].text {
                if let newPointsAsInt = Int(newPoints) {
                    self.playToButton.setTitle("Play To: \(newPoints)", forState: .Normal)
                    self.pointsToWin = newPointsAsInt
                }
            }
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}
