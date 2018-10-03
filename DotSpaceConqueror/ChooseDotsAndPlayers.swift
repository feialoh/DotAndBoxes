//
//  ChooseDotsAndPlayers.swift
//  DotSpaceConqueror
//
//  Created by Feialoh Francis on 29/11/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import UIKit


class ChooseDotAndPlayers: UIView {


    // My custom view from the XIB file
    
    
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    
    
    @IBOutlet weak var containerView: UIView!
    
    var view: UIView!
    var dotButtons:UIButton!
    var selectedNo:Int = 0
    var valueStoreKey:String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    init(type: String, frame: CGRect, selectedNo:Int)
    {

        super.init(frame:frame)
        
        self.selectedNo = selectedNo
        self.valueStoreKey = type
        self.view = Utilities.loadViewFromNib("ChooseDotsAndPlayers", atIndex: 0, aClass: Swift.type(of: self),parent:self) as? UIView
        self.view.frame = frame
        self.view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        topMargin.constant = IS_IPAD ? 75:50
        
        if type == NO_DOTS
        {
            if IS_IPAD
            {
                setupNumberButtons(3, range: 7)
            
            }
            else
            {
                setupNumberButtons(3, range: 5)
            }
        }
        else
        {
            setupNumberButtons(2, range: 2)
        }
        
        toggleSelectedButtonState()
        
        addSubview(self.view)

    }
    
   
    func setupNumberButtons(_ from:Int, range:Int)
    {
        
        var rows:Int = 2, dotBtnTag:Int = from
        
        let btnSize:CGFloat = UIScreen.main.bounds.size.width/7
        
        var x:CGFloat = (UIScreen.main.bounds.size.width - btnSize*(CGFloat(rows)+1))/2
        
        var y:CGFloat = headingLabel.frame.origin.y + headingLabel.frame.size.height
        
        
       
        
        for _ in stride(from: from, through: from+range, by: rows) // through <=, to <
        {
            for _ in 0 ..< rows
            {
                dotButtons = UIButton(type: UIButton.ButtonType.custom)
                dotButtons.addTarget(self, action: #selector(ChooseDotAndPlayers.dotButtonAction(_:)), for: UIControl.Event.touchUpInside)
                dotButtons.frame = CGRect(x: x, y: y, width: btnSize, height: btnSize)
                dotButtons.layer.cornerRadius = dotButtons.frame.height/2
                dotButtons.layer.borderWidth = dotButtons.frame.height/10
                dotButtons.layer.borderColor = Utilities.ColorCodeRGB(0x616161).cgColor
                dotButtons.tag = dotBtnTag
                dotButtons.setTitle(String(dotBtnTag), for: UIControl.State())
                dotButtons.setTitleColor(Utilities.ColorCodeRGB(0x616161), for: UIControl.State())
                dotButtons.setTitleColor(Utilities.ColorCodeRGB(0xe65b0b), for: UIControl.State.selected)
                dotButtons.titleLabel?.font = UIFont(name: "NotSoStoutDeco", size: dotButtons.frame.height/2)!
                containerView.addSubview(dotButtons)
                dotBtnTag += 1
                x += dotButtons.frame.size.width + btnSize
            }
            
            x = (UIScreen.main.bounds.size.width - btnSize*(CGFloat(rows)+1))/2
            y += dotButtons.frame.size.height + (IS_IPAD ? btnSize/2:btnSize)
        }


    }
    
    @objc func dotButtonAction(_ sender:UIButton!)
    {
        Utilities.print("\(sender.tag) pressed" )
        
        selectedNo = sender.tag
        Utilities.storeDataToDefaults(self.valueStoreKey, data: selectedNo as AnyObject)
        toggleSelectedButtonState()
    }
    
    func toggleSelectedButtonState()
    {
        for element in containerView.subviews
        {
            if element.isKind(of: UIButton.self)
            {
                let tempButton:UIButton = element as! UIButton
                if (element.tag == selectedNo)
                {
                    tempButton.isSelected = true
                    tempButton.layer.borderColor = Utilities.ColorCodeRGB(0xe65b0b).cgColor
                }
                else
                {
                    tempButton.isSelected = false
                    tempButton.layer.borderColor = Utilities.ColorCodeRGB(0x616161).cgColor
                }
            }
        }

    }

}

