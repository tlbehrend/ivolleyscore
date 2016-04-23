//
//  MaterialButtonView.swift
//  ivolleyscore
//
//  Created by Terry Behrend on 4/12/16.
//  Copyright © 2016 jbapps. All rights reserved.
//

import UIKit

class MaterialButtonView: UIButton {
    
    override func awakeFromNib() {
        layer.cornerRadius = 3.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
    }
}
