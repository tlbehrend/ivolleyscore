//
//  Constants.swift
//  ivolleyscore
//
//  Created by Terry Behrend on 2/7/16.
//  Copyright © 2016 jbapps. All rights reserved.
//

import Foundation
import UIKit

let SHADOW_COLOR: CGFloat = 157.0 / 255.0

// keys
let KEY_UID = "uid"

// cell identifiers
let CELL_MATCHCELL = "MatchCell"

// segues
let SEGUE_ENTER_TEAMS = "enter_teams"
let SEGUE_MATCH_SEARCH = "match_search"
let SEGUE_SCOREBOARD = "scoreboard"
let SEGUE_SCORING_TOOL = "scoring_tool"

// login status codes
let STATUS_INVALID_EMAIL = -5
let STATUS_INVALID_PWD = -6
let STATUS_ACCOUNT_NONEXIST = -8
let STATUS_NETWORK_ERROR = -15

// login status codes for Firebase 3
let FB_AUTH_INVALID_EMAIL = 17008
let FB_AUTH_PWD_TOO_SHORT = 17026
let FB_AUTH_INVALID_PWD = 17009
let FB_AUTH_USER_NOT_FOUND = 17011
let FB_AUTH_NETWORK_ERROR = 17020

// adMob IDs
let ADMOB_SCORING_TOOL_BANNER_ID = "ca-app-pub-1123048845597310/9937716782"
let ADMOB_SCOREBOARD_BANNER_ID = "ca-app-pub-1123048845597310/8740185180"
