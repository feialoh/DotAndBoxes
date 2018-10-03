//
//  HelpView.swift
//  DotSpaceConqueror
//
//  Created by Feialoh Francis on 05/12/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import UIKit

class HelpView: UIView {
    
    
    // My custom view from the XIB file
    
    
    @IBOutlet weak var headingLabel: UILabel!
    
    var view: UIView!
    var valueStoreKey:String!
    
    @IBOutlet weak var helpText: UITextView!
    
    
    @IBOutlet weak var multiPlayerHelpText: UITextView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    init(type: String, frame: CGRect)
    {
        
        super.init(frame:frame)
        
        self.valueStoreKey = type
        self.view = Utilities.loadViewFromNib("HelpView", atIndex: 0, aClass: Swift.type(of: self),parent:self) as? UIView
        self.view.frame = frame
        self.view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        initializeContent()
        addSubview(self.view)
        
    }
 
    func initializeContent()
    {
        helpText.text               = GAME_RULES
        multiPlayerHelpText.text    = MP_RULES
    }
    
}
