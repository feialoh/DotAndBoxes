//
//  ViewController.swift
//  DotSpaceConqueror
//
//  Created by feialoh on 19/10/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

protocol CenterViewControllerDelegate {
    func toggleLeftPanel()
    func collapseSidePanels()
    
}

protocol SaveButtonDelegate {
    func saveData()
    
}

class CenterViewController: UIViewController {

    
    
    @IBOutlet weak var singlePlayerButton: UIButton!
    
    @IBOutlet weak var multiplayerButton: UIButton!
    
    @IBOutlet weak var multiplayerDiffDevice: UIButton!
    
    @IBOutlet weak var gameCenter: UIButton!
    
    @IBOutlet weak var playGameBg: UIImageView!
    
    @IBOutlet weak var playGameView: UIView!
    
    var gameType:String = "", currentSelection:String = ""
    
    var dotNo:Int = 3, playerNos:Int = 2
    
    var delegate: CenterViewControllerDelegate?
    
    var saveDelegate: SaveButtonDelegate?
    
    var menus: Array<SoundMenuItems> = []
    
    var saveButton: UIBarButtonItem!
    
    var settingsDetails:Dictionary<String,Any>!
    
    var soundDetails:Dictionary<String,Any>!
    
    
    //MARK:- View Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //7 13 21
//        singlePlayerButton.layer.cornerRadius = singlePlayerButton.frame.size.height/2
//        multiplayerButton.layer.cornerRadius = singlePlayerButton.frame.size.width/21
//        multiplayerDiffDevice.layer.cornerRadius = singlePlayerButton.frame.size.width/21
//        gameCenter.layer.cornerRadius = singlePlayerButton.frame.size.width/21
        
//        multiplayerButton.titleLabel!.numberOfLines = 1;
//        multiplayerButton.titleLabel!.adjustsFontSizeToFitWidth = true
//        multiplayerButton.titleLabel!.lineBreakMode = NSLineBreakMode.ByClipping
        
       Utilities.print("\(singlePlayerButton.frame.size.width)-(\(singlePlayerButton.frame.size.height))-\( singlePlayerButton.layer.cornerRadius)")
        
//        singlePlayerButton.titleLabel!.font =  Utilities.myFontWithSize(FONT_SIZE)
//        multiplayerButton.titleLabel!.font =  Utilities.myFontWithSize(FONT_SIZE)
//        multiplayerDiffDevice.titleLabel!.font =  Utilities.myFontWithSize(FONT_SIZE)
//        gameCenter.titleLabel!.font =  Utilities.myFontWithSize(FONT_SIZE)

        
        customizeNavBar()
        initializeValues()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidLayoutSubviews() {
//        Utilities.print("\(#function)-\(singlePlayerButton.frame.size.width)-(\(singlePlayerButton.frame.size.height))-\( singlePlayerButton.layer.cornerRadius)")
        super.viewDidLayoutSubviews()

        
        singlePlayerButton.layer.cornerRadius = singlePlayerButton.frame.size.height/2
        multiplayerButton.layer.cornerRadius = singlePlayerButton.frame.size.height/2
        multiplayerDiffDevice.layer.cornerRadius = singlePlayerButton.frame.size.height/2
        gameCenter.layer.cornerRadius = singlePlayerButton.frame.size.height/2
        
       

        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        
        super.viewWillAppear(true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Button Actions

    @IBAction func singlePlayerButtonAction(_ sender: UIButton)
    {
//         Utilities.print("\(singlePlayerButton.frame.size.width)-(\(singlePlayerButton.frame.size.height))-\( singlePlayerButton.layer.cornerRadius)")
        Analytics.logEvent("single_player", parameters: nil)
        
        gameType = "Single"
        self.performSegue(withIdentifier: MAINGAME_VC_SEGUE, sender: self)
    
    }
    
    
    @IBAction func MPSameButtonAction(_ sender: AnyObject)
    {
        Analytics.logEvent("multiplayer_same_device", parameters: nil)
        
        gameType = "MultipleSame"
        self.performSegue(withIdentifier: MAINGAME_VC_SEGUE, sender: self)
    }
    
    
    @IBAction func MPDifferentButtonAction(_ sender: UIButton)
    {
        Analytics.logEvent("multiplayer_different_device", parameters: nil)

        gameType = "Mutliplayer"
        self.performSegue(withIdentifier: MAINGAME_VC_SEGUE, sender: self)
        
    }
    

    @IBAction func gameCenterButtonAction(_ sender: UIButton)
    {
        Analytics.logEvent("game_center", parameters: nil)

        gameType = "GameCenter"
        self.performSegue(withIdentifier: MAINGAME_VC_SEGUE, sender: self)
    }

    
    
    @objc func doneButtonPressed()
    {
        if currentSelection == SETTINGS || currentSelection == SOUND
        {
            saveDelegate?.saveData()
        }
        removeViewIfExists(ChooseDotAndPlayers.classForCoder())
        removeViewIfExists(SettingsView.classForCoder())
        removeViewIfExists(HelpView.classForCoder())
        removeViewIfExists(SoundMenuView.classForCoder())
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func menuButtonPressed()
    {
        Utilities.print("Menu button was pressed")
        //        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.delegate!.toggleLeftPanel()
        //        })
    }
    
    //MARK:- Navigation Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MAINGAME_VC_SEGUE
        {
            initializeValues()
            
            let mainGameVc = segue.destination as! MainGameViewController
            mainGameVc.gameType     = gameType
            mainGameVc.noOfDots     = dotNo
            mainGameVc.playerCount  = playerNos
            mainGameVc.setDetails   = settingsDetails
        }

    }
    
    
    func customizeNavBar()
    {
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "menu_icon"), for: UIControl.State())
        //add function for button
        button.addTarget(self, action: #selector(CenterViewController.menuButtonPressed), for: UIControl.Event.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 25)
        
        let barButton = UIBarButtonItem(customView: button)
        
        
        let rightButton = UIButton(type: UIButton.ButtonType.custom)
        rightButton.setImage(UIImage(named: "doneButton"), for: UIControl.State())
        rightButton.addTarget(self, action: #selector(CenterViewController.doneButtonPressed), for: UIControl.Event.touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 44, height: 25)
        
        saveButton = UIBarButtonItem(customView: rightButton)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.titleView = Utilities.getMyNavTitleView("Dot Space Conqueror")
    }
    
    
    //MARK:- Helper Methods

    
    func initializeValues()
    {
        if Utilities.checkValueForKey(NO_DOTS)
        {
            
            dotNo = Utilities.getDefaultValue(NO_DOTS) as! Int
        }
        else
        {
            if UIDevice.current.userInterfaceIdiom == .pad
            {
                dotNo = 4
            }
            else
            {
                dotNo = 3
            }
        }
        
        if Utilities.checkValueForKey(NO_PLAYERS) && gameType != "Single"
        {
            
            playerNos = Utilities.getDefaultValue(NO_PLAYERS) as! Int
        }
        else
        {
            playerNos = 2
        }
        
        if Utilities.checkValueForKey(SETTINGS)
        {
            //show details
            
            settingsDetails = Utilities.getDefaultValue(SETTINGS) as? Dictionary<String,Any>
//            Utilities.print("\(settingsDetails)")
            
        }
        else
        {
            settingsDetails = ["single":UIDevice.current.name as AnyObject, "multiplesame":["Player1","Player2","Player3","Player4","Player5"],"startFirst":true]
        }
        
        if Utilities.checkValueForKey(SOUND)
        {

            soundDetails = Utilities.getDefaultValue(SOUND) as? Dictionary<String,Any>

        }
        else
        {
            soundDetails = ["music":[0,0], "sound":true, "volume":0.5 as Float]
        }
        
        if soundDetails["sound"] as! Bool
        {
            playSong()
        }
        

        
    }
    
    
    func playSong(){

        menus = SoundMenuItems.allSoundMenu()
        var newIndex = soundDetails["music"] as! [Int]
        let volume = soundDetails["volume"] as! Float
        let selectedIndexPath = IndexPath(row: newIndex[0], section: newIndex[1])
        
        if let audioPlayer = SoundManager.sharedInstance.audioPlayer
        {
            if !audioPlayer.isPlaying
            {
                SoundManager.sharedInstance.playSong(fileName: menus[(selectedIndexPath as NSIndexPath).row].title, fileType: "mp3", volume:volume)
            }
        }
        else
        {
            SoundManager.sharedInstance.playSong(fileName: menus[(selectedIndexPath as NSIndexPath).row].title, fileType: "mp3", volume:volume)
        }
        

    }
    
}

extension CenterViewController: SidePanelViewControllerDelegate  {
    func menuSelected(_ menuItems: MenuItems) {
//        imageView.image = MenuItems.image
//        titleLabel.text = MenuItems.title
//        creatorLabel.text = MenuItems.creator
        Utilities.print("\(menuItems.title)")
        
        currentSelection = menuItems.title
        initializeValues()
        switch(menuItems.title)
        {
        
        case PLAY_GAME:
            
//            Utilities.print("\(self.view.subviews)")
//            self.view.bringSubviewToFront(self.playGameBg)
//            self.view.bringSubviewToFront(self.playGameView)
            removeViewIfExists(ChooseDotAndPlayers.classForCoder())
            removeViewIfExists(SettingsView.classForCoder())
            removeViewIfExists(HelpView.classForCoder())
            removeViewIfExists(SoundMenuView.classForCoder())
            
            self.navigationItem.rightBarButtonItem = nil
            break
        
        case NO_DOTS:
           
            let myView: ChooseDotAndPlayers = ChooseDotAndPlayers.init(type: NO_DOTS, frame: CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height),selectedNo:dotNo)

            myView.headingLabel.text = NO_DOTS
            
            removeViewIfExists(myView.classForCoder)
            
            self.view.addSubview(myView)
            self.navigationItem.rightBarButtonItem = saveButton
            break
            
        case NO_PLAYERS:
            
            let myView: ChooseDotAndPlayers = ChooseDotAndPlayers.init(type: NO_PLAYERS, frame: CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height),selectedNo:playerNos)
            
            myView.headingLabel.text = NO_PLAYERS
            
            removeViewIfExists(myView.classForCoder)
            
            self.view.addSubview(myView)
            
            self.navigationItem.rightBarButtonItem = saveButton
            
            break
            
        case SETTINGS:
            
            let myView: SettingsView = SettingsView.init(type: SETTINGS,frame: CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height),parent:self)
            
            
            myView.settingsHeading.text = SETTINGS

            
            removeViewIfExists(myView.classForCoder)
            
            self.view.addSubview(myView)

            self.navigationItem.rightBarButtonItem = saveButton
            
            break
            
        case HELP:
            
            let myView: HelpView = HelpView.init(type: SETTINGS,frame: CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            
            removeViewIfExists(myView.classForCoder)
            
            self.view.addSubview(myView)
            
            self.navigationItem.rightBarButtonItem = saveButton
            break
            
        case SOUND:
            
            let myView: SoundMenuView = SoundMenuView.init(type: SOUND, frame: CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height),parent:self)

            removeViewIfExists(myView.classForCoder)

    
            self.view.addSubview(myView)
            
            self.navigationItem.rightBarButtonItem = saveButton
            break
            
        default:
            break
            
        }

        delegate!.collapseSidePanels()
    }
    
    func removeViewIfExists(_ myView:AnyClass)
    {

        
//        Utilities.print("\(myView)")
        for element in self.view.subviews
        {
            if element.isKind(of: myView)
            {
                element.removeFromSuperview()
            }
        }
        
    }
    
}

