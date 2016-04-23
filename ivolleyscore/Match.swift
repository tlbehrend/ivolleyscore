//
//  Match.swift
//  ivolleyscore
//
//  Created by Terry Behrend on 2/8/16.
//  Copyright © 2016 jbapps. All rights reserved.
//

import Foundation

class Match {
    
    private var _homeName: String!
    private var _awayName: String!
    private var _homeScore: String!
    private var _awayScore: String!
    private var _matchDate: String!
    private var _matchKey: String!
    private var _homeSets: String!
    private var _awaySets: String!
    
    var homeName: String {
        return _homeName
    }
    
    var awayName: String {
        return _awayName
    }
    
    var homeScore: String {
        return _homeScore
    }
    
    var awayScore: String {
        return _awayScore
    }
    
    var homeSets: String {
        return _homeSets
    }
    
    var awaySets: String {
        return _awaySets
    }
    
    var matchDate: String {
        return _matchDate
    }
    
    var matchKey: String {
        return _matchKey
    }
    
    init(matchKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._matchKey = matchKey
        
        if let homeName = dictionary["homeTeam"] as? String {
            self._homeName = homeName
        }
        
        if let awayName = dictionary["awayTeam"] as? String {
            self._awayName = awayName
        }
        
        if let homeScore = dictionary["homeScore"] as? Int {
            self._homeScore = String(homeScore)
        }
        
        if let awayScore = dictionary["awayScore"] as? Int {
            self._awayScore = String(awayScore)
        }
        
        if let matchDate = dictionary["date"] as? String {
            self._matchDate = matchDate
        }
        
        if let awaySets = dictionary["awaySets"] as? Int {
            self._awaySets = String(awaySets)
        }
        
        if let homeSets = dictionary["homeSets"] as? Int {
            self._homeSets = String(homeSets)
        }
        
        
    }
    
}


