//
//  MainGameViewController.swift
//  DotSpaceConqueror
//
//  Created by feialoh on 20/11/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity
import GameKit


class MainGameViewController: UIViewController,UIAlertViewDelegate,MultipeerViewDelegate,FinalScoreViewDelegate,GKLocalPlayerListener {
    
   
    
    @IBOutlet weak var mainGameBg: UIImageView!
    
//    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var playerTurn: UILabel!
    
    
    @IBOutlet weak var dotContainerView: UIView!
    
    var noOfDots, playerCount:Int?

    var  dataToSend:Dictionary<String,AnyObject>!
    
    var arrConnectedDevices: [MCPeerID] = []
    var playerMarked:[Int] = []
    
    var optimalButton1, optimalButton2, optimalButton3, optimalButton4, logArray:[[Int]]?
    
    var noOfDotsTxt: UITextField!
    var player:MCPeerID!
    var playerChange: Bool = false,selfTurn: Bool = false,changeActive:Bool = false
    
    var iValue: Int = 0,colorValue:Int = 0, playerPlayIndex:Int = 1
    
    var gameType, difficultyLevel:String?
    
    var viewWidthHeight:CGFloat = 0.0, plylblSize:CGFloat = 20
    var buttonX, buttonY:UIButton!
    
    var viewArray: [ViewDetail]!
    var verticalArray:[ButtonDetail]!, horizontalArray:[ButtonDetail]!
    var noOfPlayers: [PlayerDetail]!
    var selectedButtons: [(Int,Int)]!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var setDetails:Dictionary<String,Any>!
    var Ypos:CGFloat = 0.0
    var currentObserver:AnyObject?
    
    
    //GC Temp methods
    
    var foundMatch : Bool = false

    //MARK:- View Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrConnectedDevices = []
        playerMarked = []
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        customizeNavBar()

        if gameType == "MultipleSame"
        {
            initiatePlay()
            
        }
        else if gameType == "Single"
        {
            initiatePlay()
            
            if  !(setDetails["startFirst"] as! Bool)
            {
                Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(MainGameViewController.playForCpu), userInfo: nil, repeats: false)
                
            }
        }
        else if gameType == "Mutliplayer"
        {
            
            let controller = storyboard!.instantiateViewController(withIdentifier: "multiPeerView") as! MultipeerViewController
            controller.dotNo = noOfDots!
            controller.mpDelegate = self
            addChildViewController(controller)
            controller.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(controller.view)
            controller.didMove(toParentViewController: self)
        }
        else
        {
            
//            findMatch() Game center
            
            /* Set Delegate UIViewController
            EGC.sharedInstance(self)
            
            /** If you want not message just delete this line **/
            EGC.debugMode = true
            
            EGC.delegate = self
            
            Utilities.myActivityIndicator("Loading...", self.view)
             */

        }
//        self.view.bringSubview(toFront: bannerView)
//        bannerView.isHidden = true
    }
    /*
    func EGCAuthentified(_ authentified:Bool) {
        
        Utilities.hideMyActivityIndicator()
        Utilities.print("\n[MainViewController] Player Authentified = \(authentified)\n")
        
        if authentified
        {
            EGC.findMatchWithMinPlayers(2, maxPlayers: 4)
        }
        else
        {
            EGC.showGameCenterAuthentication({
                (resultOpenGameCenter) -> Void in
                
                Utilities.print("\n[MainViewController] Show Game Center\n")
            })

        }
    }
    */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Set New view controller delegate for GC */
//        if gameType == "GameCenter"
//        {
//            EGC.delegate = self
//        }
       
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if currentObserver != nil
        {
            NotificationCenter.default.removeObserver(currentObserver!)
        }
        
//        if appDelegate.mpcManager != nil
//        {
//            if appDelegate.mpcManager.session != nil
//            {
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                self.appDelegate.mpcManager.session.disconnect()
//                self.appDelegate.mpcManager.session = nil
//                })
//            }
//        }
    }


    //MARK:- Multipeer Delegates Actions
    
    func startGameForMultipeer(_ gameDetails: Dictionary<String, Int>,cObserver:AnyObject)
    {
        currentObserver = cObserver
//        appDelegate.mpcManager.delegate = self
        Utilities.print("GAMEDETAILS:\(gameDetails)")
        
        Utilities.print("mpcManager:\(String(describing: appDelegate.mpcManager.peer))")
        
        arrConnectedDevices.append(appDelegate.mpcManager.peer)
        noOfPlayers = []
        noOfPlayers.append(PlayerDetail.init(playerID: appDelegate.mpcManager.peer, playerName: appDelegate.mpcManager.peer.displayName)!)

        Utilities.print("Connected=\(appDelegate.mpcManager.session.connectedPeers)")
        
        for connectedPeer in appDelegate.mpcManager.session.connectedPeers
        {
           arrConnectedDevices.append(connectedPeer)
           noOfPlayers.append(PlayerDetail.init(playerID: connectedPeer, playerName: connectedPeer.displayName)!)
        }
        
        noOfPlayers.sort(by: { $0.playerName.compare($1.playerName) == .orderedAscending })
        
        Utilities.print("noOfPlayers=\(String(describing: noOfPlayers))-\(noOfPlayers.count)")
        
        player = noOfPlayers[0].playerID
        
        noOfDots = gameDetails[NO_DOTS]
        
        initiatePlay()
        
        
        
    }
    
    func disconnectedPlayer(_ dPlayer: MCPeerID) {
        
        if arrConnectedDevices.count > 0
        {
            arrConnectedDevices = arrConnectedDevices.filter{ $0 != dPlayer }
            noOfPlayers = noOfPlayers.filter{ $0.playerID != dPlayer }
        
        }
        noOfPlayers.sort(by: { $0.playerName.compare($1.playerName) == .orderedAscending })
        
        if (iValue>noOfPlayers.count)
        {
            iValue -= 1
        }
        
        player = noOfPlayers[iValue-1].playerID
        setPlayerTurnForMultiplayer()
    }
    
    func receivedDataFromOthers(_ receivedData: [String : AnyObject]) {
        
        noOfPlayers.sort(by: { $0.playerName.compare($1.playerName) == .orderedAscending })
        
        if let val = receivedData["tag"] {
  
        let sender:UIButton = viewWithTagForButton(val as! Int)

                markLineAction(sender)
        }
        else if let val = receivedData["Reset"] {
            
            changeStatusForPlayer(val as! MCPeerID)

            let playStatus = noOfPlayers.filter{ $0.playerReadyStatus != true}
            if playStatus.count == 0
            {
                Utilities.hideMyActivityIndicator()
                setPlayerInteractionStatus(true)
            }
        }
        
        
    }
    
    
    //MARK:- Button Actions
    
    @objc func sendButtonAction(_ sender:UIButton!)
    {
        
        dataToSend = ["tag":sender.tag as AnyObject, "player":appDelegate.mpcManager.peer.displayName as AnyObject,"id":appDelegate.mpcManager.peer]
        
        
        Utilities.print("DataToSend-\(String(describing: dataToSend))")
        
        if(gameType == "Single")
        {
            selfTurn = false
            setPlayerInteractionStatus(false)
            markLineAction(sender)
        }
        else if(gameType == "MultipleSame")
        {
            markLineAction(sender)
        }
        else
        {
            
            if arrConnectedDevices.count > 0
            {
                var error:NSError?
                
                let data : Data = NSKeyedArchiver.archivedData(withRootObject: dataToSend)
                
                do {
                    try self.appDelegate.mpcManager.session.send(data, toPeers: appDelegate.mpcManager.session.connectedPeers, with: MCSessionSendDataMode.reliable)
                } catch let error1 as NSError {
                    error = error1
                }
                
                if error != nil
                {
                    DispatchQueue.main.async(execute: {
                        self.present(Utilities.showAlertViewMessageAndTitle("No other players in session", title: "Error", delegate: [], cancelButtonTitle: "OK"), animated: true, completion: nil)
                    })
                    Utilities.print("error: \(String(describing: error?.localizedDescription))")
                    Utilities.hideMyActivityIndicator()
                    setPlayerInteractionStatus(true)
                }
                else
                {
                    receivedDataFromOthers(dataToSend)
                }
                
                
                
            }
            else
            {
                DispatchQueue.main.async(execute: {
                    self.present(Utilities.showAlertViewMessageAndTitle("Connection Lost", title: "Error", delegate: [], cancelButtonTitle: "OK"), animated: true, completion: nil)
                })
                Utilities.hideMyActivityIndicator()
                setPlayerInteractionStatus(true)
            }

        }
        
    }
    
    func resetButtonAction()
    {
//        Utilities.print("Before:\(self.view.subviews)")
        
//        for element in self.view.subviews
//        {
//            if !element.isKind(of: GADBannerView.self)
//            {
//                element.removeFromSuperview()
//            }
//
//            
//        }
        
        for element in dotContainerView.layer.sublayers!
        {
            if element.name == "lines"
            {
                element.removeFromSuperlayer()
               
            }

            
        }
        
        for viewItem in dotContainerView.subviews
        {
            if viewItem.isKind(of: UIView.self) || viewItem.isKind(of: UIButton.self)
            {
                viewItem.removeFromSuperview()
            }
            else
            {
                Utilities.print("Tag=\(viewItem.tag)")
            }
        }

        
        Utilities.print("Count=\(dotContainerView.subviews.count)")
        
        playerTurn.isHidden = false
        
        if( gameType == "Mutliplayer")
        {
            
            notifyOtherPlayersForReset()
            
//            playerTurn = UILabel(frame: CGRect(x: 130,y: 50,width: 150, height: 20.0))
//            playerTurn.autoresizingMask = UIViewAutoresizing.flexibleWidth
//            playerTurn.backgroundColor = UIColor.clear
//            self.view.addSubview(playerTurn)
            
            selfTurn = true
            playerChange = true
            Utilities.print("ivalue=\(iValue),playindex=\(playerPlayIndex)")
            colorValue = 0
            noOfPlayers.sort(by: { $0.playerName.compare($1.playerName) == .orderedAscending })
            
            if (playerPlayIndex%noOfPlayers.count == 0)
            {
                playerPlayIndex = 1
            }
            else
            {
                playerPlayIndex += 1
            }
 
            iValue = playerPlayIndex
            player = noOfPlayers[iValue-1].playerID
            setPlayerTurnForMultiplayer()
            makeGridWithNoOfDots()
            
            let playStatus = noOfPlayers.filter{ $0.playerReadyStatus != true}
            if playStatus.count > 0
            {
                Utilities.myActivityIndicator("Waiting for players", self.view)
                setPlayerInteractionStatus(false)
            }

        }
        else
        {
            initiatePlay()
        }
        
//        bannerView.isHidden = false
//        self.view.bringSubview(toFront: bannerView)
 

    }
    
    @objc func backButtonPressed()
    {
        DispatchQueue.main.async(execute: { () -> Void in
            self.appDelegate.mpcManager.session.disconnect()
        })
         _ = self.navigationController?.popViewController(animated: true)
    }
    
    
//MARK:- Game Play Functions
    
    //To initiate game play
    func initiatePlay()
    {
//        showAds()
        selectedButtons = []
//        playerTurn = UILabel(frame: CGRect(x: 130,y: 50,width: 150, height: 20));
//        playerTurn.autoresizingMask = UIViewAutoresizing.flexibleWidth
//        playerTurn.backgroundColor = UIColor.clear
//        self.view.addSubview(playerTurn)
        
        selfTurn     =  true
        playerChange =  true
        iValue       =  1
        colorValue   =  0

        
        if (gameType == "Single" || gameType == "MultipleSame")
        {
            noOfPlayers = []
            
            var multiplayerNames:[String] = []
            multiplayerNames = (setDetails["multiplesame"] as? [String])!
            
            for i in 0...playerCount!-1
            {
                let tempID: MCPeerID = MCPeerID.init(displayName: "ID\(i+1)")
                
                if(i==1 && gameType == "Single")
                {
                    noOfPlayers.append(PlayerDetail.init(playerID: tempID, playerName: "CPU")!)
                    if  !(setDetails["startFirst"] as! Bool)
                    {
                        iValue += 1
                    }

                }
                else
                {
                    if gameType == "Single"
                    {
                        noOfPlayers.append(PlayerDetail.init(playerID: tempID, playerName: setDetails["single"] as! String)!)
                    }
                    else
                    {
                        noOfPlayers.append(PlayerDetail.init(playerID: tempID, playerName: multiplayerNames[i])!)
                    }
                    
                }
            
            }
            
            player  = noOfPlayers[iValue-1].playerID
            
            
            
            if Utilities.filterString(noOfPlayers[iValue-1].playerName).count == 0
            {
                playerTurn.text = "Player's Turn"
            }
            else
            {
                playerTurn.text =  noOfPlayers[iValue-1].playerName+"'s turn"
                playerTurn.font = Utilities.myFontWithSize(plylblSize)
                playerTurn.textColor = UIColor.yellow
//                Utilities.adjustTurnLabel(plylblSize,myLabel: playerTurn)
            }

            
        }
         else if gameType == "Mutliplayer"
        {
            
            //Handle for Multipeer connectivity
            setPlayerTurnForMultiplayer()
            
        }
        else
        {
            //set player
            player  = noOfPlayers[iValue-1].playerID
            
            if Utilities.filterString(noOfPlayers[iValue-1].playerName).count == 0
            {
                playerTurn.text = "Player's Turn"
            }
            else
            {
                playerTurn.text =  noOfPlayers[iValue-1].playerName+"'s turn"
                playerTurn.font = Utilities.myFontWithSize(plylblSize)
                playerTurn.textColor = UIColor.yellow
//                Utilities.adjustTurnLabel(plylblSize,myLabel: playerTurn)
            }

        }

        makeGridWithNoOfDots()
    }
    
    
    //To create the view for dots
    func makeGridWithNoOfDots()
    {
        var x, y, scaleFactor, margin: CGFloat
        
        var btnTag: Int = 1, viewTag :Int = 1
        
//        var i, j:Int
        
        verticalArray = []
        horizontalArray = [];
        viewArray = [];

        //check iphone or ipad and set margin
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            margin = 150
        }
        else
        {
            margin = 50
        }
        viewWidthHeight = UIScreen.main.bounds.size.width - margin
        
        scaleFactor = (viewWidthHeight/((3*CGFloat(noOfDots!))-2))

        x = (UIScreen.main.bounds.size.width-viewWidthHeight)/2
//        y = (UIScreen.main.bounds.size.height-viewWidthHeight)/2
        
        y = playerTurn.frame.origin.y + playerTurn.frame.size.height
        
        
       
        
        for i in 0 ..< noOfDots!
        {
            for j in 0 ..< noOfDots!
            {
                let circleView: UIImageView = UIImageView(frame: CGRect(x: x,y: y,width: scaleFactor,height: scaleFactor))
                circleView.layer.cornerRadius = circleView.frame.size.height/2;
                circleView.backgroundColor = UIColor.white
                dotContainerView.addSubview(circleView)
                
                if (j != noOfDots!-1)
                {
                    buttonX = UIButton(type: UIButtonType.custom)
                    buttonX.addTarget(self, action: #selector(MainGameViewController.sendButtonAction(_:)), for: UIControlEvents.touchUpInside)
                    buttonX.frame = CGRect(x: circleView.frame.origin.x+circleView.frame.size.width, y: y, width: 2*scaleFactor, height: scaleFactor);
                    buttonX.tag = btnTag
//                    buttonX.backgroundColor = UIColor.greenColor()
                    dotContainerView.addSubview(buttonX)
                    

                    horizontalArray.append(ButtonDetail(btnId: btnTag, startEnd: (i*noOfDots!+j, i*noOfDots!+j+1), btnActive: false)!)

                    
                }
                 btnTag += 1
                
                
                if (i != noOfDots!-1)
                {
                    buttonY = UIButton(type: UIButtonType.custom)
                    buttonY.addTarget(self, action: #selector(MainGameViewController.sendButtonAction(_:)), for: UIControlEvents.touchUpInside)
                    buttonY.frame = CGRect(x: circleView.frame.origin.x, y: circleView.frame.origin.y+circleView.frame.size.height,width: scaleFactor,height: 2*scaleFactor);
                    buttonY.tag = btnTag
//                    buttonY.backgroundColor = UIColor.redColor()
                    dotContainerView.addSubview(buttonY)

                    verticalArray.append(ButtonDetail(btnId: btnTag, startEnd: (i*noOfDots!+j, i*noOfDots!+j+noOfDots!), btnActive: false)!)

                    
                }
                btnTag += 1
                
                if (i != noOfDots!-1 && j != noOfDots!-1)
                {
                    let paintView = UIView(frame: CGRect(x: buttonX.frame.origin.x,y: buttonX.frame.origin.y+buttonX.frame.size.height, width: 2*scaleFactor, height: 2*scaleFactor))
//                    paintView.backgroundColor = UIColor.blueColor()
                    paintView.tag = viewTag
                    dotContainerView.addSubview(paintView)
                    
                    var xy:[(Int,Int)]
                    var x1, y1:Int
                    
                    x1 = i*noOfDots!+j
                    y1 = noOfDots!*(i+1)+j
                    
                    xy  = [(x1, y1)]
                    xy += [(x1, y1-(noOfDots!-1))]
                    xy += [(y1, y1+1)]
                    xy += [(x1+1, y1+1)]

                    viewArray.append(ViewDetail(viewId: viewTag, xy: xy, activeStatus:[false,false,false,false], viewDisplay: false, currentPlayer:MCPeerID.init(displayName: "Test"))!)

                    
                    viewTag += 1
                }
                 x += 3*scaleFactor
                
            }
            x = (UIScreen.main.bounds.size.width-viewWidthHeight)/2
            y += 3*scaleFactor
        }
        
//        if noOfDots!%2 != 0
//        {
            y -= 2*scaleFactor
//        }
        
        Ypos = y
        
//        scaleFactor = viewWidthHeight/10
        
        scaleFactor = 40
        
       /* // Logs
        Utilities.print("Horizontal Array\n")
        for index in 0...horizontalArray.count-1
        {
            var temp:ButtonDetail?
            
            temp = horizontalArray[index]
            Utilities.print("[\(temp!.btnId)-\(temp!.startEnd)-\(temp!.btnActive)]")
        }
        
        Utilities.print("Vertical Array\n")
        for index in 0...verticalArray.count-1
        {
            var temp:ButtonDetail?
            
            temp = verticalArray[index]
            Utilities.print("[\(temp!.btnId)-\(temp!.startEnd)-\(temp!.btnActive)]")
        }
        
        Utilities.print("View Array\n")
        for index in 0...viewArray.count-1
        {
            var temp:ViewDetail?
            
            
            
            temp = viewArray[index]
            Utilities.print("[\(temp!.viewId)-\(temp!.xy)-\(temp!.activeStatus.count)-\(temp!.viewDisplay)-\(temp!.currentPlayer)]")
            
                for element in temp!.activeStatus
                {
                    Utilities.print("\(index+1)==\(element)")
                }
        }
    */
    
        
    }
    

    
    
    
    func markLineAction(_ sender:UIButton!)
    {
        
        
        sender.isSelected = true
        sender.isUserInteractionEnabled = false
        

        
        
        Utilities.print("MARKED BUTTON TAG:\(sender.tag)");
        
//        let scaleFactor:CGFloat = (viewWidthHeight/((3*CGFloat(noOfDots!))-2))
//        
//        let strokeColor : UIColor = noOfPlayers[iValue-1].color[iValue-1]
//        
//        let path:UIBezierPath = UIBezierPath.init()
//        path.moveToPoint(CGPointMake(10.0, 10.0))
//        path.addLineToPoint(CGPointMake(290.0, 10.0))
//        path.lineWidth = 5*0.5*(11-CGFloat(noOfDots!))
//        
//        Utilities.print("LINE WIDTH:\(path.lineWidth) for \(noOfDots) Dots")
//        
//        let dashes = [path.lineWidth, path.lineWidth * 2]
//        path.setLineDash(dashes, count: 2, phase: 0)
//        path.lineCapStyle = CGLineCap.Square
//        
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(2*scaleFactor, 20), false, 2);
//        strokeColor.setStroke()
//        path.stroke()
//        
//        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();

//        var i: Int = 0
        
        var temp:ButtonDetail?
        

        
        if (sender.tag%2 == 0)
        {
            
            for i in 0 ..< verticalArray.count
            {
                temp = verticalArray[i]
                
                if ( temp?.btnId == sender.tag)
                {
                    temp?.btnActive = true
                     drawLine(sender.frame.origin, ofSize: sender.frame.size, direction: "vertical")
                    checkForGridFill((temp?.startEnd)!)
//                    sender.setImage(rotateImage(image, degrees: 90), forState: .Selected)
                   
                    break
                }
            }
        }
        else
        {
            for i in 0 ..< horizontalArray.count
            {
                temp = horizontalArray[i]
                if ( temp?.btnId == sender.tag)
                {
                    temp?.btnActive = true
                    drawLine(sender.frame.origin, ofSize: sender.frame.size, direction: "horizontal")
                    checkForGridFill((temp?.startEnd)!)
//                    sender.setImage(image, forState:.Selected)
                    
                    break
                }

            }
        }
        
        checkForWinStatus()
        
        
        if (!selfTurn && gameType == "Single")
        {
            Utilities.print("CPU is going to play")
            
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(MainGameViewController.playForCpu), userInfo: nil, repeats: false)
        }
    }
    
    
    func checkForGridFill(_ xy:(Int,Int))
    {
//        var i: Int = 0, j: Int = 0
        var temp:ViewDetail?
        changeActive = true
        
        for i in 0 ..< viewArray.count
        {
            temp = viewArray[i]
            for j in 0 ..< 4
            {
                 if ((temp?.xy[j].0 == xy.0) && (temp?.xy[j].1 == xy.1)) || ((temp?.xy[j].0 == xy.1) && (temp?.xy[j].1 == xy.0))
                 {
                    temp?.activeStatus[j] = true
                    selectedButtons.append(xy)
                    changeBackgroundForView()
                 }
            }
        }
        
        changePlayerTurn()
    }
    
    //To check and color the view if all four sides are clicked around the view
    func changeBackgroundForView()
    {
//        var i: Int = 0, j: Int = 0
        var temp:ViewDetail?

        for i in 0 ..< viewArray.count
        {
            temp = viewArray[i]
            for j in 0 ..< 4
            {
                if (temp?.activeStatus[j] == false)||(temp?.viewDisplay == true)
                {
                    break
                }
                else if (j == 3)
                {
                    if (gameType == "Single" && changeActive == true)
                    {
                        selfTurn = !selfTurn
                        self.view.isUserInteractionEnabled = !self.view.isUserInteractionEnabled
                        changeActive = false
                    }
                    
                    playerChange = false
                    
                    temp?.viewDisplay = true
                    UIView.animate(withDuration: 0.5, animations:
                        {
                            self.viewWithTagNotCountingSelf(temp!.viewId).backgroundColor = self.noOfPlayers[self.iValue-1].color[self.iValue-1]

                        }, completion:nil)
                    temp?.currentPlayer = player
                }
            }
        }
        

    }

    
    func checkForWinStatus()
    {
        var limit:Int = 0 //, i: Int = 0, j:Int = 0
        var temp:ViewDetail?
        
        var playerTitle: [[String:Any]] = []
        
        for i in 0 ..< noOfPlayers.count
        {
            playerTitle.append(["player":noOfPlayers[i].playerName as AnyObject,"id":noOfPlayers[i].playerID,"fillCount":0 as AnyObject,"Color":noOfPlayers[i].color[i]])
        }
        
        limit = (noOfDots!-1)*(noOfDots!-1);
        
        for i in 0 ..< viewArray.count
        {
            temp = viewArray[i]
            
            if temp?.viewDisplay == false
            {
                break;
            }
            else if (i==limit-1)
            {
                selfTurn = true
                
                for i in 0 ..< viewArray.count
                {
                     temp = viewArray[i]
                    for j in 0 ..< noOfPlayers.count
                    {
                        if temp?.currentPlayer == noOfPlayers[j].playerID
                        {
                            let fCount =  playerTitle[j]["fillCount"] as! Int
                            playerTitle[j].updateValue(fCount+1, forKey: "fillCount")

                        }

                    }
                    
                }
                
//                Utilities.print("\(playerTitle),\(String(describing: logArray))");
                
                
                
                playerTurn.isHidden = true
                setPlayerInteractionStatus(true)
//                bannerView.isHidden = true

                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainGameViewController.showScoreAlert(_:)), userInfo: playerTitle, repeats: false)
                
                
            }
        }

    }
    
    @objc func showScoreAlert(_ timer:Timer)
    {
//        Utilities.print("\(timer.userInfo)")
        
        var playerInfo =  timer.userInfo as! [[String:AnyObject]]
        
        playerInfo.sort {
            item1, item2 in
            let date1 = item1["fillCount"] as! Int
            let date2 = item2["fillCount"] as! Int
            return date1 > date2
        }
        
//        Utilities.print("\(playerInfo)")
        
        
        let finalAlert:FinalScoreView = FinalScoreView.init(frame: CGRect(x: 0,y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), playerDetails: playerInfo, parentView:self.view)
        finalAlert.delegate = self
        finalAlert.show()
        resetPlayerStatus()
    }
    
    
    
    
    func changePlayerTurn()
    {
        if (playerChange == true)
        {
            
            
            if (iValue%noOfPlayers.count == 0)
            {
                iValue = 1
            }
            else
            {
                iValue += 1
            }
            
            player = noOfPlayers[iValue-1].playerID
            
            if Utilities.filterString(noOfPlayers[iValue-1].playerName).count == 0
            {
                playerTurn.text = "Player's Turn"
            }
            else
            {
                playerTurn.text =  noOfPlayers[iValue-1].playerName+"'s turn"
                playerTurn.font = Utilities.myFontWithSize(plylblSize)
                playerTurn.textColor = UIColor.yellow
//                Utilities.adjustTurnLabel(plylblSize,myLabel: playerTurn)
            }
            
            setPlayerTurnForMultiplayer()
        }
        else
        {
            
            playerChange = true
        }

    }
    
    @objc func playForCpu()
    {

        var optimalButton1: [(Int,Int)] = []
        var optimalButton2: [(Int,Int)] = []
        var optimalButton3: [(Int,Int)] = []
        var optimalButton4: [(Int,Int)] = []
        
        var pointArray: [(Int,Int)]
        
        var activeCount:Int
        
        var cpuSelect:UIButton!
        
//        var i: Int = 0, j: Int = 0 , k:Int = 0
        var temp:ViewDetail
        
        for i in 0 ..< viewArray.count
        {
            temp = viewArray[i]
            activeCount = 0;
            pointArray = []
            for j in 0 ..< 4
            {
                if temp.viewDisplay == true
                {
                    activeCount = 5
                    break
                    
                }
                else if temp.activeStatus[j] == true
                {
                    activeCount += 1
                }
                else
                {
                    pointArray += [(temp.xy[j].0,temp.xy[j].1)]
                }
            }
                if activeCount == 3
                {
                    for k in 0 ..< pointArray.count
                    {
                        optimalButton1 += [(pointArray[k].0, pointArray[k].1)]
                    }
                }
                else if(activeCount == 0)
                {
                    for k in 0 ..< pointArray.count
                    {
                        optimalButton2 += [(pointArray[k].0, pointArray[k].1)]
                    }
                }
                else if(activeCount == 1)
                {
                   for k in 0 ..< pointArray.count
                    {
                        optimalButton3 += [(pointArray[k].0, pointArray[k].1)]
                    }
                }
                else if(activeCount == 2)
                {
                    for k in 0 ..< pointArray.count
                    {
                        optimalButton4 += [(pointArray[k].0, pointArray[k].1)]
                    }
                }
            
        }
        
        
            optimalButton1 = filterDuplicatesFrom(optimalButton1)
            optimalButton2 = filterDuplicatesFrom(optimalButton2)
            optimalButton3 = filterDuplicatesFrom(optimalButton3)
            optimalButton4 = filterDuplicatesFrom(optimalButton4)
            

            optimalButton2 = deletePoints(optimalButton4,buttonArrays: optimalButton2)
            
            optimalButton3 = deletePoints(optimalButton4,buttonArrays: optimalButton3)
            
            selectedButtons = filterDuplicatesFrom(selectedButtons)
        
            if (optimalButton1.count > 0)
            {
                optimalButton1 = deletePoints(selectedButtons,buttonArrays: optimalButton1)
                cpuSelect = getOptimalButton(optimalButton1)
            }
            else if (optimalButton2.count > 0)
            {
                optimalButton2 = deletePoints(selectedButtons,buttonArrays: optimalButton2)
                cpuSelect = getOptimalButton(optimalButton2)
            }
            else if (optimalButton3.count > 0)
            {
                optimalButton3 = deletePoints(selectedButtons,buttonArrays: optimalButton3)
                cpuSelect = getOptimalButton(optimalButton3)
            }
            else
            {
                optimalButton4 = deletePoints(selectedButtons,buttonArrays: optimalButton4)
                cpuSelect = getOptimalButton(optimalButton4)
            }
            
            selfTurn = true
        
            setPlayerInteractionStatus(true)
        Utilities.print("CPU HAS SELECTED:\(String(describing: cpuSelect))")
            markLineAction(cpuSelect)
        
    }
    
    
    
    func customizeNavBar()
    {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "back_icon"), for: UIControlState())
        //add function for button
        button.addTarget(self, action: #selector(MainGameViewController.backButtonPressed), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 25)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.titleView = Utilities.getMyNavTitleView("Dot Space Conqueror")
    }
    
//MARK:- Final Score delegate
    
    func quitButtonTouched() {
        
        DispatchQueue.main.async(execute: { () -> Void in
            self.appDelegate.mpcManager.session.disconnect()
        })
        _ = self.navigationController?.popViewController(animated: true)
        
       
    }
    
    func restartButtonTouched() {
        
        resetButtonAction()
    }
    
    
//MARK:- Helper Methods
    
    
    //Ad showing method
    
//    func showAds()
//    {
//        Utilities.print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
//        
//        bannerView.adUnitID = AdUnitId
//        bannerView.rootViewController = self
//        bannerView.adSize = kGADAdSizeSmartBannerPortrait
//        let request = GADRequest()
//        request.testDevices = [ kGADSimulatorID ]
//        bannerView.load(request)
//    }
    
    
    func rotateImage(_ image:UIImage, degrees:CGFloat)-> UIImage
    {
        let rotatedViewBox:UIView = UIView.init(frame: CGRect(x: 0,y: 0,width: image.size.width, height: image.size.height))
        let t:CGAffineTransform = CGAffineTransform(rotationAngle: (.pi * degrees)/180);
        rotatedViewBox.transform = t;
        let rotatedSize:CGSize = rotatedViewBox.frame.size
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap:CGContext = UIGraphicsGetCurrentContext()!;
    
    
        bitmap.translateBy(x: rotatedSize.width, y: rotatedSize.height);
        bitmap.rotate(by: (.pi * degrees)/180);
        bitmap.scaleBy(x: 1.0, y: -1.0);
        bitmap.draw(image.cgImage!, in: CGRect(x: -image.size.width, y: -image.size.height, width: image.size.width, height: image.size.height))
    
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        return newImage
    
    }

    
    //To get the view which is to be colored
    func viewWithTagNotCountingSelf(_ tags:Int) -> UIView
    {
        var myView:UIView = UIView.init()

        for element in dotContainerView.subviews
        {
            if element.isKind(of: UIView.self)
            {
                if (element.tag == tags)
                {
                    myView = element
                }
            }
        }

    return myView
    }
    
    //To get the button to be marked
    func viewWithTagForButton(_ tags:Int) -> UIButton
    {
        var myView:UIButton = UIButton.init()
        
        for element in dotContainerView.subviews
        {
            if element.isKind(of: UIButton.self)
            {
                if (element.tag == tags)
                {
                    myView = element as! UIButton
                }
            }
        }
        
        return myView
    }

    func filterDuplicatesFrom(_ buttonArrays:[(Int,Int)]) ->[(Int,Int)]
    {
        var buttonArray = buttonArrays
//        var i: Int = 0, j:Int = 0
        if buttonArray.count > 0
        {
        var elementToDelete:[Int] = []
        for i in 0 ..< buttonArray.count-1
        {
            for j in 0 ..< buttonArray.count-1
            {
                if buttonArray[j].0 == buttonArray[i].0 &&  buttonArray[j].1 == buttonArray[i].1
                {
                    if !elementToDelete.contains(j)
                    {
                        elementToDelete.append(j)
                    }
                }
            }
        }
        
        buttonArray.removeAtIndices(elementToDelete)
        }
        return buttonArray
        
    }

func deletePoints(_ deleteLists:[(Int,Int)],buttonArrays:[(Int,Int)]) ->[(Int,Int)]
{
    var buttonArray = buttonArrays
    
    var deleteList = deleteLists
    
//    var i: Int = 0, j:Int = 0
    var elementToDelete:[Int] = []
    for i in 0 ..< buttonArray.count
    {
       for j in 0 ..< deleteList.count
        {
            if deleteList[j].0 == buttonArray[i].0 &&  deleteList[j].1 == buttonArray[i].1
            {
                if !elementToDelete.contains(i)
                {
                    elementToDelete.append(i)
                }
            }
        }
    }
    
    buttonArray.removeAtIndices(elementToDelete)
    
    return buttonArray
}
    
    
    func getOptimalButton( _ buttonArrays:[(Int,Int)]) -> UIButton
    {
        var buttonArray = buttonArrays
        var indx:Int = 0
//        var i: Int = 0
    if (buttonArray.count-1 > 0)
    {
        indx = Int(arc4random_uniform(UInt32(buttonArray.count-1)))
    }
    else
    {
        indx = 0
    }
    
     var temp:ButtonDetail
    Utilities.print("CPU SELECTION:\(buttonArray[indx].0),\(buttonArray[indx].1)")
        
    for i in 0 ..< verticalArray.count
    {
        temp = verticalArray[i]
        
        if (temp.startEnd.0 == buttonArray[indx].0 && temp.startEnd.1 == buttonArray[indx].1) || (temp.startEnd.0 == buttonArray[indx].1 && temp.startEnd.1 == buttonArray[indx].0)
        {
            return viewWithTagForButton(temp.btnId)
    
        }
    }
        
        
       for i in 0 ..< horizontalArray.count  
        {
            temp = horizontalArray[i]
            
            if (temp.startEnd.0 == buttonArray[indx].0 && temp.startEnd.1 == buttonArray[indx].1) || (temp.startEnd.0 == buttonArray[indx].1 && temp.startEnd.1 == buttonArray[indx].0)
            {
                return viewWithTagForButton(temp.btnId)
                
            }
        }
        
    return UIButton.init()

}
    
    
    func drawLine( _ fromPoint:CGPoint, ofSize:CGSize, direction:String)
    {
        var fromPoints = fromPoint
        var toPoint:CGPoint = CGPoint.init()
        let scaleFactor:CGFloat = (viewWidthHeight/((3*CGFloat(noOfDots!))-2))
        
        if direction == "horizontal"
        {
            fromPoints.y +=  ofSize.height/2
            toPoint.x = fromPoints.x + ofSize.width
            toPoint.y = fromPoints.y
            
            fromPoints.x += scaleFactor/4
            toPoint.x -= scaleFactor/4
        }
        else
        {
            fromPoints.x +=  ofSize.width/2
            toPoint.y = fromPoints.y + ofSize.height
            toPoint.x = fromPoints.x
            
            fromPoints.y += scaleFactor/4
            toPoint.y -= scaleFactor/4
        }
        
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: fromPoints.x, y: fromPoints.y))
        path.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        // Create a CAShape Layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.frame = dotContainerView.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = noOfPlayers[iValue-1].color[iValue-1].cgColor //UIColor.redColor().CGColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth =  scaleFactor/2  //5*0.5*(11-CGFloat(noOfDots!))
//        pathLayer.lineJoin = kCALineJoinBevel
        pathLayer.lineCap = kCALineCapRound
        pathLayer.name = "lines"
        // Add layer to views layer
        dotContainerView.layer.addSublayer(pathLayer)
        
        // Basic Animation
        let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.duration = 0.5
        pathAnimation.fromValue = NSNumber(value: 0.0 as Float)
        pathAnimation.toValue = NSNumber(value: 1.0 as Float)
        
        // Add Animation
        pathLayer.add(pathAnimation, forKey: "strokeEnd")
        
    }
    
    
    func setPlayerTurnForMultiplayer()
    {
        if gameType == "Mutliplayer"
        {
            
            if appDelegate.mpcManager.peer != player
            {
                playerTurn.text = "Its \(Utilities.filterString(player.displayName))'s turn"
                setPlayerInteractionStatus(false)
            }
            else
            {
                playerTurn.text = "Its your turn"
                setPlayerInteractionStatus(true)
            }
            playerTurn.font = Utilities.myFontWithSize(plylblSize)
            playerTurn.textColor = UIColor.yellow
//            Utilities.adjustTurnLabel(plylblSize,myLabel: playerTurn)
        }
    }
    
    
    
    func setPlayerInteractionStatus(_ values:Bool)
    {
        var value = values
        for element in dotContainerView.subviews
        {
            Utilities.print(element)
            if element.isKind(of: FinalScoreView.classForCoder())
            {
               value = true
                break
            }
        }
        
        for element in dotContainerView.subviews
        {
            if element.isKind(of: UIView.self)
            {
                if element.tag == 777
                {
                    value = false
                    break
                }
                
            }
        }
        
  
        self.view.isUserInteractionEnabled = value
    }
    
    func logPlayer()
    {
        for element in noOfPlayers
        {
            Utilities.print("\(element.playerName)=\(element.playerReadyStatus)")
        }
    }
    
    
    // Change all player ready status to false after game completion
    
    func resetPlayerStatus()
    {

        noOfPlayers = noOfPlayers.map({ (player) -> PlayerDetail in
            player.playerReadyStatus = false
            return player
        })
        
//        noOfPlayers = noOfPlayers.map { unwrappedNoOfPlayers in
//            unwrappedNoOfPlayers.map { playerElement in
//                playerElement.playerReadyStatus = false; return playerElement
//            }
//        }
//        noOfPlayers = noOfPlayers.map{ $0.playerReadyStatus = false; return $0}
        
    }
    
    
    //Change ready status of particular player
    
    func changeStatusForPlayer(_ readyPlayer:MCPeerID)
    {
        noOfPlayers = noOfPlayers.map({ (player) -> PlayerDetail in
            if player.playerID == readyPlayer {
            player.playerReadyStatus = true
            }
            return player
        })
        
//        noOfPlayers = noOfPlayers.map{ if $0.playerID == readyPlayer
//        {
//            $0.playerReadyStatus = true
//            }
//            return $0
//        }
//        for element in noOfPlayers
//        {
//            Utilities.print("\(element.playerName)=\(element.playerReadyStatus)")
//        }
    }
    
    //To notify reset action for other players
    
    func notifyOtherPlayersForReset()
    {
        if arrConnectedDevices.count > 0
        {
            dataToSend = ["Reset":appDelegate.mpcManager.peer]
            var error:NSError?
            
            let data : Data = NSKeyedArchiver.archivedData(withRootObject: dataToSend)
            
            do {
                try self.appDelegate.mpcManager.session.send(data, toPeers: appDelegate.mpcManager.session.connectedPeers, with: MCSessionSendDataMode.reliable)
            } catch let error1 as NSError {
                error = error1
            }
            
            if error != nil
            {
                DispatchQueue.main.async(execute: {
                    self.present(Utilities.showAlertViewMessageAndTitle("No other players in session", title: "Error", delegate: nil, cancelButtonTitle: "OK"), animated: true, completion: nil)
                })
                Utilities.print("error: \(String(describing: error?.localizedDescription))")
            }
            else
            {
              changeStatusForPlayer(appDelegate.mpcManager.peer)
            }
            
        }
        else
        {
            DispatchQueue.main.async(execute: {
                self.present(Utilities.showAlertViewMessageAndTitle("Connection Lost", title: "Error", delegate: nil, cancelButtonTitle: "OK"), animated: true, completion: nil)
            })
        }
        
    }

    

    // MARK: GKMatchmakerViewControllerDelegate
    
    /*####################################################################################################*/
    /*                         Delegate Mutliplayer Easy Game Center                                      */
    /*####################################################################################################*/
    /**
     Match Start, Delegate Func of Easy Game Center
     */
    /*
    func EGCMatchStarted() {
        Utilities.print("\n[MultiPlayerActions] MatchStarted")
        
        noOfPlayers = []
        
        if let players = EGC.getPlayerInMatch() {
            for player in players{
                Utilities.print(player.alias)
                noOfPlayers.append(PlayerDetail.init(playerID: MCPeerID.init(displayName: player.alias!), playerName: player.alias!)!)
            }
        }
        
        noOfPlayers.append(PlayerDetail.init(playerID: MCPeerID.init(displayName: "ME"), playerName: setDetails["single"] as! String)!)
        
        
         noOfDots = 4
        
        initiatePlay()

        
//        self.TextLabel.text = "Match Started !"
    }
    /**
     Match Recept Data (When you send Data this function is call in the same time), Delegate Func of Easy Game Center
     */
    func EGCMatchRecept(_ match: GKMatch, didReceiveData data: Data, fromPlayer playerID: String) {
        
        // See Packet
        let autre =  Packet.unarchive(data)
        Utilities.print("\n[MultiPlayerActions] Recept From player = \(playerID)")
        Utilities.print("\n[MultiPlayerActions] Recept Packet.name = \(autre.name)")
        Utilities.print("\n[MultiPlayerActions] Recept Packet.index = \(autre.index)")
        
//        self.TextLabel.text = "Recept Date From \(playerID)"
    }
    /**
     Match End / Error (No NetWork example), Delegate Func of Easy Game Center
     */
    func EGCMatchEnded() {
        Utilities.print("\n[MultiPlayerActions] MatchEnded")
//        self.TextLabel.text = "Match Ended !"
    }
    /**
     Match Cancel, Delegate Func of Easy Game Center
     */
    func EGCMatchCancel() {
        Utilities.print("\n[MultiPlayerActions] Match cancel")
    }

    */
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
}

extension Array {
    mutating func removeAtIndices(_ incs: [Int]) {
        incs.sorted(by: >).forEach{ remove(at: $0) }
    }
}
