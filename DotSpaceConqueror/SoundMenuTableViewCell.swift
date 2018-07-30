//
//  SoundMenuTableViewCell.swift
//  DotSpaceConqueror
//
//  Created by feialoh on 14/01/16.
//  Copyright © 2016 Cabot. All rights reserved.
//

import UIKit

class SoundMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var copyRightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
