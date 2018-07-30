//
//  FinalScoreTableViewCell.swift
//  DotSpaceConqueror
//
//  Created by feialoh on 18/01/16.
//  Copyright © 2016 Cabot. All rights reserved.
//

import UIKit

class FinalScoreTableViewCell: UITableViewCell {

    @IBOutlet weak var playerName: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
