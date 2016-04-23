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

    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    @IBOutlet weak var homeSetsLabel: UILabel!
    @IBOutlet weak var awaySetsLabel: UILabel!
    @IBOutlet weak var homeServingImg: UIImageView!
    @IBOutlet weak var awayServingImg: UIImageView!

    @IBOutlet weak var setsToWinButton: UIButton!
    
    
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
        homeScoreLabel.text = String(Int(homeScoreLabel.text!)! + 1)
        homeServingImg.hidden = false
        awayServingImg.hidden = true
        DataService.ds.REF_MATCHES.childByAppendingPath(matchKey).childByAppendingPath("homeScore").setValue(Int(homeScoreLabel.text!)!)
        DataService.ds.REF_MATCHES.childByAppendingPath(matchKey).childByAppendingPath("homeServing").setValue(true)
        DataService.ds.REF_MATCHES.childByAppendingPath(matchKey).childByAppendingPath("awayServing").setValue(false)
        
        if homeTeamWinner() {
            if Int(homeSetsLabel.text!)! + 1 >= setsToWin {
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
        // if this is single game match (setsToWin == 1) or this is NOT last game
        // the game will go to 25, otherwise, it will go to 15
        if (setsToWin == 1 || Int(homeSetsLabel.text!)! + Int(awaySetsLabel.text!)! + 1 < totalPossibleSets) {
            if Int(homeScoreLabel.text!)! >= 25 && (Int(homeScoreLabel.text!)! - Int(awayScoreLabel.text!)!) > 1 {
                return true
            }
            return false
        }
        else {
            if Int(homeScoreLabel.text!)! >= 15 && (Int(homeScoreLabel.text!)! - Int(awayScoreLabel.text!)!) > 1 {
                return true
            }
            return false
        }
        
    }
    
    func awayTeamWinner() -> Bool {
        // if this is single game match (setsToWin == 1) or this is NOT last game
        // the game will go to 25, otherwise, it will go to 15
        if (setsToWin == 1 || Int(awaySetsLabel.text!)! + Int(homeSetsLabel.text!)! + 1 < totalPossibleSets) {
            if Int(awayScoreLabel.text!)! >= 25 && (Int(awayScoreLabel.text!)! - Int(homeScoreLabel.text!)!) > 1 {
                return true
            }
            return false
        }
        else {
            if Int(awayScoreLabel.text!)! >= 15 && (Int(awayScoreLabel.text!)! - Int(homeScoreLabel.text!)!) > 1 {
                return true
            }
            return false
        }
        
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
    
    
}
