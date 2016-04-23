//
//  StartNewMatchController.swift
//  ivolleyscore
//
//  Created by Terry Behrend on 2/7/16.
//  Copyright © 2016 jbapps. All rights reserved.
//

import UIKit

class StartNewMatchController: UIViewController {
    
    var newMatch: String?

    @IBOutlet weak var team1TextField: UITextField!
    
    @IBOutlet weak var team2TextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        team1TextField.text = ""
        team2TextField.text = ""
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
    
    @IBAction func goBack() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func addMatchToFirebase() {
        if let homeTeam = team1TextField.text where homeTeam != "", let awayTeam = team2TextField.text where awayTeam != "" {
            
            // add all the data needed for the match to a dictionary
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            let today = dateFormatter.stringFromDate(NSDate())
            
            let match: Dictionary<String, AnyObject> = [
                "homeTeam": homeTeam,
                "homeScore": 0,
                "awayTeam": awayTeam,
                "awayScore": 0,
                "homeSets": 0,
                "awaySets": 0,
                "homeServing": true,
                "awayServing": false,
                "date": today,
                "completed": false
            ]
            let firebaseMatch = DataService.ds.REF_MATCHES.childByAutoId()
            firebaseMatch.setValue(match)
            newMatch = firebaseMatch.key
            
            self.performSegueWithIdentifier(SEGUE_SCORING_TOOL, sender: nil)
            
        }
        else {
            showErrorAlert("Missing Team Name", msg: "You must enter names for both teams")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  SEGUE_SCORING_TOOL {
            if let destinationVC = segue.destinationViewController as? ScoringToolViewController {
                destinationVC.matchKey = newMatch
                //print("destinationVC data set to: \(newMatch)")
            }
            else {
                print("wrong type VC")
            }
            
        }
        else{
            print("wrong segue identifier")
        }
    }
    
    func showErrorAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

}
