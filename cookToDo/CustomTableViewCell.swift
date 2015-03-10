//
//  CustomTableViewCell.swift
//  cookToDo
//
//  Created by 田上健太 on 2/27/15.
//  Copyright (c) 2015 SonicGarden. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var webView: UIWebView!

    var ingredient = Ingredient()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
