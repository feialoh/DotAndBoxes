//
//  SettingsView.swift
//  DotSpaceConqueror
//
//  Created by Feialoh Francis on 05/12/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import UIKit

class SettingsView: UIView,SaveButtonDelegate,UITextFieldDelegate {

    var view: UIView!
    var valueStoreKey:String!
    
    var settingsData:Dictionary<String,Any>!
    
    var startStatus:Bool!
    
    let limitLength = 20
    
    @IBOutlet weak var settingsHeading: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var playerRealName: UITextField!
    
    @IBOutlet weak var playFirstSwitch: UISwitch!
    
    @IBOutlet weak var player1Name: UITextField!
    
    
    @IBOutlet weak var player2Name: UITextField!
    
    
    @IBOutlet weak var player3Name: UITextField!
    
    
    @IBOutlet weak var player4Name: UITextField!
    
    
    @IBOutlet weak var player5Name: UITextField!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(type: String, frame: CGRect,parent:CenterViewController)
    {
        
        
        super.init(frame:frame)
        self.valueStoreKey = type
        self.view = Utilities.loadViewFromNib("SettingsView", atIndex: 0, aClass: Swift.type(of: self),parent:self) as! UIView
        self.view.frame = frame
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        print("\(scrollView)")
        parent.saveDelegate = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "whitebg")!)
        addSubview(self.view)
        initializeSettings()
    }

    
    func initializeSettings()
    {
        if Utilities.checkValueForKey(self.valueStoreKey)
        {
           //show details
            
            settingsData = Utilities.getDefaultValue(self.valueStoreKey) as! Dictionary<String,Any>
            print("\(settingsData)")
            
            
        }
        else
        {
            startStatus = true
            settingsData = ["single":UIDevice.current.name as AnyObject, "multiplesame":["Player1","Player2","Player3","Player4","Player5"],"startFirst":startStatus]
        }
        
        playerRealName.text = settingsData["single"] as? String
        print("\(settingsData)")
        var multiplayerNames:[String] = []
        multiplayerNames = (settingsData["multiplesame"] as? [String])!
        print("\(multiplayerNames)")
        player1Name.text = multiplayerNames[0]
        player2Name.text = multiplayerNames[1]
        player3Name.text = multiplayerNames[2]
        player4Name.text = multiplayerNames[3]
        player5Name.text = multiplayerNames[4]
        
        startStatus = settingsData["startFirst"] as! Bool
        playFirstSwitch.isOn = startStatus
    }
    
    // MARK: Center View save delegate implementation
    
    func saveData() {
        settingsData = ["single":playerRealName.text! as AnyObject, "multiplesame":[player1Name.text!,player2Name.text!,player3Name.text!,player4Name.text!,player5Name.text!],"startFirst":startStatus]
        
        Utilities.storeDataToDefaults(self.valueStoreKey, data: settingsData as AnyObject)
    }
    
    
    // MARK: Switch Action
    
    @IBAction func playFirstAction(_ sender: UISwitch) {
        
            startStatus = sender.isOn
    }
    
    
     // MARK: Text Field Delegates implementation
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("\(textField.frame.origin.y + textField.frame.size.height)==\(self.view.frame.height - 250)")
        if (textField.frame.origin.y + textField.frame.size.height) > (self.view.frame.height - 250)
        {
            scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= limitLength
    }
}


