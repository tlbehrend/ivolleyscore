//
//  MatchSearchViewController.swift
//  ivolleyscore
//
//  Created by Terry Behrend on 2/8/16.
//  Copyright © 2016 jbapps. All rights reserved.
//

import UIKit
import Firebase

class MatchSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController: UISearchController!

    @IBOutlet weak var tableView: UITableView!
    
    var chosenMatch:String!
    
    var matches = [Match]()
    var filteredMatches = [Match]()
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let today = dateFormatter.stringFromDate(NSDate())
        
        // search only today's matches
        
        DataService.ds.REF_MATCHES.queryOrderedByChild("date").queryEqualToValue(today).observeEventType(.Value, withBlock: {
            
            snapshot in
            
            print(snapshot.value)
            self.matches = []
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    //print("SNAP: \(snap)")
                    
                    if let matchDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let match = Match(matchKey: key, dictionary: matchDict)
                        
                        self.matches.append(match)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
        
        // search all matches
        
//        DataService.ds.REF_MATCHES.observeEventType(.Value, withBlock: {
//            snapshot in
//            
//            print(snapshot.value)
//            self.matches = []
//            
//            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
//                
//                for snap in snapshots {
//                    print("SNAP: \(snap)")
//                    
//                    if let matchDict = snap.value as? Dictionary<String, AnyObject> {
//                        let key = snap.key
//                        let match = Match(matchKey: key, dictionary: matchDict)
//                        
//                        self.matches.append(match)
//                    }
//                }
//            }
//            
//            self.tableView.reloadData()
//        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            return filteredMatches.count
        }
        else {
            return matches.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var match: Match
        
        if shouldShowSearchResults {
            match = filteredMatches[indexPath.row]
        }
        else {
            match = matches[indexPath.row]
        }
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(CELL_MATCHCELL) as? MatchCell {
            cell.configureCell(match)
            return cell
        }
        else {
            return MatchCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var match: Match
        
        if shouldShowSearchResults {
            match = filteredMatches[indexPath.row]
        }
        else {
            match = matches[indexPath.row]
        }
        
        chosenMatch = match.matchKey

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier(SEGUE_SCOREBOARD, sender: nil)
    
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier ==  SEGUE_SCOREBOARD {
            if let destinationVC = segue.destinationViewController as? ScoreboardViewController {
                destinationVC.chosenMatch = chosenMatch
                print("destinationVC data set to: \(chosenMatch)")
            }
            else {
                print("wrong type VC")
            }
            
        }
        else{
            print("wrong segue identifier")
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
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // Place the search bar view to the tableview headerview.
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        shouldShowSearchResults = true
//        tableView.reloadData()
//    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchString = searchController.searchBar.text where searchString != "" {
            
            shouldShowSearchResults = true
            
            // Filter the data array and get only those countries that match the search text.
            filteredMatches = matches.filter({ (match) -> Bool in
                
                return (match.homeName.lowercaseString.containsString(searchString.lowercaseString) || match.awayName.lowercaseString.containsString(searchString.lowercaseString))
            })
            
            // Reload the tableview.
            tableView.reloadData()
        }
        else {
            
            shouldShowSearchResults = false
            tableView.reloadData()
        }
        
    }

}
