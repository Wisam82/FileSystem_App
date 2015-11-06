//
//  TheatersListTableViewCell.swift
//  Project4
//
//  Created by Wisam Thalij on 11/4/15.
//  Copyright (c) 2015 Wisam. All rights reserved.
//

import UIKit

class TheatersListTableViewCell: UITableViewCell {
    
    // Mark: Properties

    @IBOutlet weak var Tkey: UILabel!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
