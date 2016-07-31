//
//  ScoreboardViewController.swift
//  ivolleyscore
//
//  Created by Terry Behrend on 2/8/16.
//  Copyright © 2016 jbapps. All rights reserved.
//

import UIKit
import Firebase

class ScoreboardViewController: UIViewController {
    

    @IBOutlet weak var homeTeamNameLabel: UILabel!
    @IBOutlet weak var awayTeamNameLabel: UILabel!
    @IBOutlet weak var homeScoreLabel: UILabel!
    @IBOutlet weak var awayScoreLabel: UILabel!
    @IBOutlet weak var homeSetsLabel: UILabel!
    @IBOutlet weak var awaySetsLabel: UILabel!
    
    @IBOutlet weak var homeServingImage: UIImageView!
    
    @IBOutlet weak var awayServingImage: UIImageView!
    
    var chosenMatch: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        print("CHOSE:\(chosenMatch)")
        
        DataService.ds.REF_MATCHES.child(chosenMatch).observeEventType(.Value, withBlock: {
            snapshot in
            
//            print(snapshot.value)
//            print(snapshot)
            
            if let score = snapshot.value as? Dictionary<String, AnyObject> {
                self.updateScoreboard(score)
            }
            
            
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateScoreboard(scoreDict: Dictionary<String, AnyObject>) {
        
        if let homeTeam = scoreDict["homeTeam"] as? String {
            homeTeamNameLabel.text = homeTeam
        }
        if let awayTeam = scoreDict["awayTeam"] as? String {
            awayTeamNameLabel.text = awayTeam
        }
        if let homeScore = scoreDict["homeScore"] as? Int {
            homeScoreLabel.text = String(homeScore)
        }
        if let awayScore = scoreDict["awayScore"] as? Int {
            awayScoreLabel.text = String(awayScore)
        }
        if let homeSets = scoreDict["homeSets"] as? Int {
            homeSetsLabel.text = String(homeSets)
        }
        if let awaySets = scoreDict["awaySets"] as? Int {
            awaySetsLabel.text = String(awaySets)
        }
        
        if let homeServing = scoreDict["homeServing"] as? Int {
            if homeServing == 0 {
                homeServingImage.hidden = true
                awayServingImage.hidden = false
            }
            else {
                homeServingImage.hidden = false
                awayServingImage.hidden = true
            }
        }
        if let awayServing = scoreDict["awayServing"] as? Int {
            if awayServing == 0 {
                homeServingImage.hidden = false
                awayServingImage.hidden = true
            }
            else {
                homeServingImage.hidden = true
                awayServingImage.hidden = false
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func goBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
