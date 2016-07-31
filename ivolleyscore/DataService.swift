//
//  DataService.swift
//  ivolleyscore
//
//  Created by Terry Behrend on 2/7/16.
//  Copyright © 2016 jbapps. All rights reserved.
//

import Foundation
import Firebase

//let URL_BASE = "https://ivolleyscore.firebaseio.com"

let rootRef = FIRDatabase.database().reference()

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = rootRef
    private var _REF_USERS = rootRef.child("users")
    private var _REF_MATCHES = rootRef.child("matches")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_MATCHES: FIRDatabaseReference {
        return _REF_MATCHES
    }
    
//    var REF_SCORER: Firebase? {
//        if let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String {
//            let user = Firebase(url: "\(URL_BASE)/users/\(uid)")
//            return user
//        }
//        return nil
//    }
    
    func createFirebaseUser(uid: String, user: Dictionary <String, String>){
        REF_USERS.child(uid).setValue(user)
    }
    
    
}
