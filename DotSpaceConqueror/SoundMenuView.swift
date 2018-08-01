//
//  SoundMenuView.swift
//  DotSpaceConqueror
//
//  Created by Feialoh Francis on 10/12/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import UIKit
import AVFoundation


class SoundMenuView: UIView,SaveButtonDelegate,UITableViewDataSource,UITableViewDelegate {

    
    var view: UIView!
    var valueStoreKey:String!
    var lastSelectedIndexPath: IndexPath!
    var menus: Array<SoundMenuItems> = []
    var soundData:Dictionary<String,Any>!
    
    @IBOutlet weak var soundSlider: UISlider!
    
    @IBOutlet weak var soundButton: UIButton!
    
    @IBOutlet weak var musicTable: UITableView!
    
    var soundStatus:Bool = true
    var volume:Float = 0.5
    
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)


    }
    
   
    init(type: String, frame: CGRect,parent:CenterViewController)
    {
        
        super.init(frame:frame)
        self.valueStoreKey = type
        self.view =  loadViewFromNib()  //Utilities.loadViewFromNib("SoundMenuView", atIndex: 0, aClass: self.dynamicType,parent:self) as! UIView
        self.view.frame = frame
        self.view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        parent.saveDelegate = self
        initializeMenu()
        musicTable.register(UINib(nibName: "SoundMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "soundMenuCell")
        musicTable.estimatedRowHeight = 150
        musicTable.rowHeight = UITableViewAutomaticDimension
        
       if let audioPlayer = SoundManager.sharedInstance.audioPlayer
       {
            if !audioPlayer.isPlaying
            {
                playGameThemeSong()
            }
        }
       
     
        addSubview(self.view)
        
    }
    
   
    func loadViewFromNib() -> (UIView) {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SoundMenuView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return (view)
    }
    
    func initializeMenu()
    {
        menus = SoundMenuItems.allSoundMenu()
        musicTable.tableFooterView = UIView()

        
        if Utilities.checkValueForKey(self.valueStoreKey)
        {
            //show details
            
            soundData = Utilities.getDefaultValue(self.valueStoreKey) as! Dictionary<String,Any>
            
        }
        else
        {
            soundData = ["music":[0,0], "sound":true, "volume":0.5]
        }
        
        Utilities.print("\(soundData)")
        soundStatus = soundData["sound"] as! Bool
        var newIndex = soundData["music"] as! [Int]
        if let vol = soundData["volume"] as? Double
        {
            volume = Float(vol)
        }

        lastSelectedIndexPath = IndexPath(row: newIndex[0], section: newIndex[1])
         if soundStatus
         {
            soundButton.isSelected = false
            soundSlider.setValue(volume, animated: true)
            soundSlider.isUserInteractionEnabled = true
         }
         else
         {
            soundButton.isSelected = true
            soundSlider.setValue(0.0, animated: true)
            soundSlider.isUserInteractionEnabled = false
         }
        
        
        
    }
    
    func saveData() {
        
        var selection:IndexPath = IndexPath(row: 0, section: 0)
        if lastSelectedIndexPath != nil
        {
            selection = lastSelectedIndexPath
        }
        soundData = ["music":[(selection as NSIndexPath).row,(selection as NSIndexPath).section], "sound":soundStatus, "volume":soundSlider.value]
         Utilities.print("\(soundData)")
        Utilities.storeDataToDefaults(self.valueStoreKey, data: soundData as AnyObject)
    }
    
    
    @IBAction func soundButtonAction(_ sender: UIButton)
    {
       
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected
        {
            
            soundSlider.setValue(0.0, animated: true)
            SoundManager.sharedInstance.audioPlayer?.stop()
            SoundManager.sharedInstance.audioPlayer?.currentTime = 0;
            soundStatus = false
            soundSlider.isUserInteractionEnabled = false
            
        }
        else
        {
            volume = 0.3
            playGameThemeSong()
            soundStatus = true
            soundSlider.isUserInteractionEnabled = true
            
        }

        
    }
    
    @IBAction func soundSlideAction(_ sender: UISlider)
    {
        SoundManager.sharedInstance.audioPlayer?.volume = sender.value
        volume = sender.value
//        soundButton.selected = (sender.value == 0)
    }
    
    
    func playGameThemeSong(){
        
        var selectedItem:Int = 0
        
        if(lastSelectedIndexPath != nil)
        {
            selectedItem = lastSelectedIndexPath.row
        }
        
//        guard let audioPlayer = SoundManager.sharedInstance.audioPlayer else { return }
        
        SoundManager.sharedInstance.playSong(fileName: menus[selectedItem].title, fileType: "mp3", volume: volume)
        soundSlider.value = volume
        
//        let audioFilePath = Bundle.main.path(forResource: menus[selectedItem].title, ofType: "mp3")
//        if audioFilePath != nil {
//            let audioFileUrl = URL(fileURLWithPath: audioFilePath!)
//            try! audioPlayer = AVAudioPlayer(contentsOf: audioFileUrl, fileTypeHint: nil)
//            audioPlayer.numberOfLoops = -1
//            audioPlayer.prepareToPlay()
//            audioPlayer.volume = volume
//            soundSlider.value  = audioPlayer.volume
//            audioPlayer.play()
//        } else {
//            Utilities.print("audio file is not found")
//        }
        
    }
    
    //MARK:- UITableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menus.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //SoundMenuView - SliderView
//        let tableCell = Utilities.loadViewFromNib("SliderView", atIndex: 1, aClass: self.dynamicType,parent:self) as? UITableViewCell ?? UITableViewCell(style: .Subtitle,reuseIdentifier: "cell")
        
         let tableCell = tableView.dequeueReusableCell(withIdentifier: "soundMenuCell") as! SoundMenuTableViewCell
        if lastSelectedIndexPath != nil
        {
            tableCell.accessoryType = ((lastSelectedIndexPath as NSIndexPath?)?.row == (indexPath as NSIndexPath).row) ? .checkmark : .none
        }
        else
        {
            tableCell.accessoryType = ((indexPath as NSIndexPath).row == 0) ? .checkmark : .none
        }
        tableCell.titleLabel?.text = menus[(indexPath as NSIndexPath).row].title
        tableCell.subTitleLabel?.text = "Artist: " + menus[(indexPath as NSIndexPath).row].artist
        tableCell.copyRightLabel?.text = menus[(indexPath as NSIndexPath).row].copyright
        
//        tableCell.titleLabel?.textColor = Utilities.ColorCodeRGB(0x616161)
//        tableCell.subTitleLabel?.textColor = Utilities.ColorCodeRGB(0x616161)
//        tableCell.copyRightLabel?.textColor = Utilities.ColorCodeRGB(0x616161)
        tableCell.backgroundColor = UIColor.clear
        return tableCell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).row != (lastSelectedIndexPath as NSIndexPath?)?.row {
            if let lastSelectedIndexPath = lastSelectedIndexPath {
                let oldCell = tableView.cellForRow(at: lastSelectedIndexPath)
                oldCell?.accessoryType = .none
            }
            
            let newCell = tableView.cellForRow(at: indexPath)
            newCell?.accessoryType = .checkmark
            
            lastSelectedIndexPath = indexPath
            tableView.reloadData()
            
            if soundStatus == true
            {
              playGameThemeSong()
            }
            
            
        }
    }

}
