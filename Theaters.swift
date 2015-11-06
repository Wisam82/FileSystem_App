//
//  Theaters.swift
//  Project4
//
//  Created by Wisam Thalij on 11/4/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import Foundation
import UIKit

class Theaters {
    
    // MARK: Properties
    var Tkeys: String
    //var photo: UIImage?
    
    // MARK: Initialization
    
    init?(Tkeys: String) {
        
        // Initialize stored properties.
        self.Tkeys = Tkeys
        //self.photo = photo
        
        // Initialization should fail if there is no name or if the rating is negative.
        if Tkeys.isEmpty {
            return nil
        }
        
    }
}

struct Theater_Keys {
    var Tkeys: String
}
