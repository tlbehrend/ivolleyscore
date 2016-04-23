//
//  MatchCell.swift
//  ivolleyscore
//
//  Created by Terry Behrend on 2/8/16.
//  Copyright © 2016 jbapps. All rights reserved.
//

import UIKit

class MatchCell: UITableViewCell {
    
    @IBOutlet weak var homeTeamName: UILabel!
    @IBOutlet weak var awayTeamName: UILabel!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var matchDate: UILabel!
    
    var match: Match!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(match: Match) {
        //self.match = match
        
        self.homeTeamName.text = match.homeName + " (\(match.homeSets))"
        self.awayTeamName.text = match.awayName + " (\(match.awaySets))"
        self.homeScore.text = match.homeScore
        self.awayScore.text = match.awayScore
        self.matchDate.text = match.matchDate
        
    }

}
