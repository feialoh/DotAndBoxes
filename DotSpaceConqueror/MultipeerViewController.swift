//
//  MultipeerViewController.swift
//  DotSpaceConqueror
//
//  Created by feialoh on 02/12/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import UIKit
import MultipeerConnectivity


protocol  MultipeerViewDelegate {
    
    func startGameForMultipeer(_ gameDetails:Dictionary<String,Int>, cObserver:AnyObject)
    
    func disconnectedPlayer(_ player:MCPeerID)
    
    func receivedDataFromOthers(_ receivedData:[String:AnyObject])
    
}


class MultipeerViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource, MPCManagerDelegate,UIAlertViewDelegate {

    
    var gameType:String = ""
    var dotNo:Int = 3, playerNos:Int = 2
    
    var userType:String = ""
    
    var placeHolderString:String = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var mpDelegate: MultipeerViewDelegate?
    
    var isAdvertising: Bool!, invitationRequest: Bool!
    
    var statusType:String = "Connecting"
    
    var inviteAlert:UIAlertController!
    
    @IBOutlet weak var playerTable: UITableView!
    
    
    @IBOutlet weak var startGame: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.print("NO of dots:\(dotNo)")
        
        let multipeerAlert = UIAlertController(title: "Host or Join?", message: "Do you wish to host a new game or join an existing one?", preferredStyle: UIAlertControllerStyle.alert)
        let Host = UIAlertAction(title: "Host", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            self.userType = "Host"
            self.appDelegate.mpcManager.advertiser.startAdvertisingPeer()
            self.placeHolderString = "Waiting for players..."
            
            self.updatePlayers()
            
        }
        
        
        let okAction = UIAlertAction(title: "Join", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            
            self.userType = "Guest"
            self.appDelegate.mpcManager.browser.startBrowsingForPeers()
            self.invitationRequest = true
            self.placeHolderString = "Searching for host..."
            
            self.updatePlayers()
        }
        
        multipeerAlert.addAction(Host)
        multipeerAlert.addAction(okAction)
        self.present(multipeerAlert, animated: true, completion: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MultipeerViewController.handleMPCReceivedStateWithNotification(_:)), name: NSNotification.Name(rawValue: "receivedMPCStateNotification"), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(MultipeerViewController.handleMPCReceivedDataWithNotification(_:)), name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: nil)
        
        
        playerTable.delegate = self
        playerTable.dataSource = self
        
//        if appDelegate.mpcManager == nil
//        {
            appDelegate.mpcManager = MPCManager()
//        }
        
        Utilities.print("Session is =\(appDelegate.mpcManager.session)")
        
        appDelegate.mpcManager.delegate = self
        // Do any additional setup after loading the view.
        
        playerTable.isHidden = true
        playerTable.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MULTITOMAIN_VC_SEGUE
        {
            let mainGameVc = segue.destination as! MainGameViewController
            mainGameVc.gameType     = gameType
            mainGameVc.noOfDots     = dotNo
            mainGameVc.playerCount  = playerNos
        }
    }


    
    
    // MARK: Button Action method implementation
    
    @IBAction func startStopAdvertising(_ sender: AnyObject) {
            let actionSheet = UIAlertController(title: "", message: "Change Visibility", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            var actionTitle: String
            if isAdvertising == true {
                actionTitle = "Make me invisible to others"
            }
            else{
                actionTitle = "Make me visible to others"
            }
            
            let visibilityAction: UIAlertAction = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default) { (alertAction) -> Void in
                if self.isAdvertising == true {
                    self.appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
                }
                else{
                    self.appDelegate.mpcManager.advertiser.startAdvertisingPeer()
                }
                
                self.isAdvertising = !self.isAdvertising
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (alertAction) -> Void in
                
            }
            
            actionSheet.addAction(visibilityAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
            
        
    }
    
    
    @IBAction func startGameAction(_ sender: UIButton) {
        
        Utilities.print("Connected players count-\(self.appDelegate.mpcManager.foundPeers.count)")
        Utilities.print("SELF ID-\(self.appDelegate.mpcManager.peer)")
        
        let messageDict = [NO_DOTS:dotNo,NO_PLAYERS:playerNos]
        
//        let messageData = try? NSJSONSerialization.dataWithJSONObject(messageDict, options: NSJSONWritingOptions.PrettyPrinted)
//        
        var error:NSError?
        
        let messageData : Data = NSKeyedArchiver.archivedData(withRootObject: messageDict)
        
        do {
            try self.appDelegate.mpcManager.session.send(messageData, toPeers: appDelegate.mpcManager.session.connectedPeers, with: MCSessionSendDataMode.reliable)
        } catch let error1 as NSError {
            error = error1
        }
        
        if error != nil
        {
            Utilities.print("error: \(String(describing: error?.localizedDescription))")
        }
        else
        {
            mpDelegate?.startGameForMultipeer(messageDict,cObserver: self)
            self.statusType = "Playing"
            self.view.removeFromSuperview()
        }

        
    }
    
    @IBAction func cancelGameAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: { () -> Void in
        self.appDelegate.mpcManager.session.disconnect()
//        self.appDelegate.mpcManager = nil
            })
        _ = self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.removeObserver(self)
        
    }

    
    // MARK: UITableView related method implementation
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if appDelegate.mpcManager.foundPeers.count == 0
        {
            return 1
        }
        
        return appDelegate.mpcManager.foundPeers.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell")! as UITableViewCell
        
        Utilities.print("cell for row entered:\(appDelegate.mpcManager.foundPeers.count)")
        if appDelegate.mpcManager.foundPeers.count == 0
        {
            let placeholderCell = tableView.dequeueReusableCell(withIdentifier: "placeholderCell")! as UITableViewCell
            
            placeholderCell.textLabel?.text = placeHolderString
            placeholderCell.backgroundColor = UIColor.clear
            placeholderCell.textLabel?.font = Utilities.myFontWithSize(FONT_SIZE-2)
            
            return placeholderCell
        }
        
        
        cell.textLabel?.text = Utilities.filterString(appDelegate.mpcManager.foundPeers[(indexPath as NSIndexPath).row].displayName)
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = Utilities.myFontWithSize(FONT_SIZE-2)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        Utilities.print("userType=\(userType)-request=\(invitationRequest)")
        if userType == "Guest" && invitationRequest == true
        {
            if appDelegate.mpcManager.foundPeers.count > 0
            {
            let selectedPeer = appDelegate.mpcManager.foundPeers[(indexPath as NSIndexPath).row] as MCPeerID
        
            appDelegate.mpcManager.browser.invitePeer(selectedPeer, to: appDelegate.mpcManager.session, withContext: nil, timeout: 20)
            
            playerTable.isUserInteractionEnabled = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(section == 0) {
            
            var titleString = "Available hosts"
            
            if userType != "Guest"
            {
                titleString = "Players Connected - \(appDelegate.mpcManager.session.connectedPeers.count)"
            }
            
            let view = UIView()
            let label1 = UILabel()
            label1.text = titleString
            label1.font = Utilities.myFontWithSize(FONT_SIZE)
            label1.translatesAutoresizingMaskIntoConstraints = false
            let views = ["label1": label1,"view": view]
            view.addSubview(label1)
            view.backgroundColor = Utilities.ColorCodeRGB(0xDBDBDB)
            let horizontallayoutContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label1]|", options: .alignAllCenterY, metrics: nil, views: views)
            view.addConstraints(horizontallayoutContraints)
            
            let verticalLayoutContraint = NSLayoutConstraint(item: label1, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            view.addConstraint(verticalLayoutContraint)
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func customizeNavBar()
    {
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "back_icon"), for: UIControlState())
        //add function for button
        button.addTarget(self, action: #selector(MultipeerViewController.cancelGameAction(_:)), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 25)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.titleView = Utilities.getMyNavTitleView("Dot Space Conqueror")
    }
    
    

    
    // MARK: MPCManagerDelegate method implementation
    
    func foundPeer() {
        Utilities.print("\(#function)triggered from MultipeerVC")
        playerTable.reloadData()
    }
    
    
    func lostPeer() {
        Utilities.print("\(#function)triggered from MultipeerVC")
        playerTable.reloadData()
    }
    
    func invitationWasReceived(_ fromPeer: String) {
        
        if self.statusType == "Connecting"
        {
            OperationQueue.main.addOperation { () -> Void in
                
                
                self.inviteAlert = UIAlertController(title: "Accept or Decline?", message: Utilities.filterString(fromPeer)+" wants to join your game.", preferredStyle: UIAlertControllerStyle.alert)
                
                let acceptAction = UIAlertAction(title: "Accept", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    
                    Utilities.print("Accept=\(self.appDelegate.mpcManager.session.connectedPeers.count)")
                    if self.appDelegate.mpcManager.session.connectedPeers.count + 1 > MAX_PLAYERS
                    {
                        DispatchQueue.main.async(execute: {
                            
                            self.present(Utilities.showAlertViewMessageAndTitle("Can't add more than 7 players", title: "Message", delegate: [], cancelButtonTitle: "OK"), animated: true, completion: nil)
                        })
                    }
                    else
                    {
                        self.appDelegate.mpcManager.invitationHandler(true, self.appDelegate.mpcManager.session)
                    }
                }
                
                // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
                
                let declineAction = UIAlertAction(title: "Decline", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    Utilities.print("Decline")
                    self.appDelegate.mpcManager.invitationHandler(false, self.appDelegate.mpcManager.session)
                }
                
                self.inviteAlert.addAction(acceptAction)
                self.inviteAlert.addAction(declineAction)
                self.present(self.inviteAlert, animated: true, completion: nil)
                
            }
        }
        else
        {
            self.appDelegate.mpcManager.invitationHandler(false, self.appDelegate.mpcManager.session)
        }

    }
    
    
    func connectedWithPeer(_ peerID: MCPeerID) {
        OperationQueue.main.addOperation { () -> Void in
//            self.performSegueWithIdentifier(MAINGAME_VC_SEGUE, sender: self)
            Utilities.print("\(peerID.displayName),peercount-\(self.appDelegate.mpcManager.foundPeers.count)")
            
            Utilities.print("Invitiation status-\(self.appDelegate.mpcManager.invitationHandler)")
            
            if !self.appDelegate.mpcManager.foundPeers.contains(peerID)
            {
               self.appDelegate.mpcManager.foundPeers.append(peerID)
            }
            
            Utilities.print("new count-\(self.appDelegate.mpcManager.foundPeers.count)")
            
             Utilities.print("Peer list-\(self.appDelegate.mpcManager.foundPeers)")
            
            if self.userType == "Host"
            {
                self.updatePlayers()
            }   
        }
       
    }
    
    func updatePlayers() {
        self.playerTable.isHidden = false
        startGame.isEnabled = (appDelegate.mpcManager.foundPeers.count > 0)
        self.playerTable.reloadData()
    }
    
    
    @objc func handleMPCReceivedStateWithNotification(_ notification: Notification) {
        // Get the dictionary containing the data and the source peer from the notification.
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        // "Extract" the data and the source peer from the received dictionary.
        let state = receivedDataDictionary["state"] as! Int
        let peerID = receivedDataDictionary["peerID"] as! MCPeerID
        
        Utilities.print("Notified-\(peerID.displayName)==\(self.appDelegate.mpcManager.peer.displayName)")
        
        var message:String = ""
        switch state{
        case MCSessionState.connected.rawValue:
            
            if statusType == "Connecting"
            {
            
            invitationRequest = false
            message = "Your invitation has been accepted. Waiting for player to start the game. Do not cancel."
            Utilities.print("\(peerID.displayName)-Connected to session: \(self.appDelegate.mpcManager.session)")
            
            if !self.appDelegate.mpcManager.foundPeers.contains(peerID)
            {
                self.appDelegate.mpcManager.foundPeers.append(peerID)

            }
            else
            {
                
                inviteAlert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    
                }
                
                inviteAlert.addAction(okAction)
                self.present(inviteAlert, animated: true, completion: nil)
            }
            
            Utilities.print("new count-\(self.appDelegate.mpcManager.foundPeers.count)")
            
            Utilities.print("Peer list-\(self.appDelegate.mpcManager.foundPeers)")
            
            if self.userType == "Host"
            {
                self.updatePlayers()
            }
            
            }
            else
            {
                
            }
          
            
        case MCSessionState.connecting.rawValue:
            invitationRequest = false
            Utilities.print(Utilities.filterString(peerID.displayName)+"-Connecting to session: \(self.appDelegate.mpcManager.session)")
            
        default:
            Utilities.print("Session State:\(state)-Disconnected")
            if statusType == "Connecting"
            {
            
            if invitationRequest == true
            {
                message = "Your invitation has been declined."
            }
            else
            {
                message = "Lost Connection with " + Utilities.filterString(peerID.displayName)
                if self.appDelegate.mpcManager.foundPeers.contains(peerID)
                {
                    let filterArray = self.appDelegate.mpcManager.foundPeers.filter { $0 != peerID }
                    self.appDelegate.mpcManager.foundPeers =  filterArray
                    
                }
                self.updatePlayers()
            }
           
            Utilities.print("\(peerID.displayName)-Did not connect to session: \(self.appDelegate.mpcManager.session)")
            
                inviteAlert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    
                }
                
                inviteAlert.addAction(okAction)
                self.present(inviteAlert, animated: true, completion: nil)
            
            invitationRequest = true
            }
            else
            {
                inviteAlert = UIAlertController(title: "Message", message: "Lost Connection with " + Utilities.filterString(peerID.displayName), preferredStyle: UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    (result : UIAlertAction) -> Void in
                    
                }
                
                inviteAlert.addAction(okAction)
                self.present(inviteAlert, animated: true, completion: nil)
                
                mpDelegate?.disconnectedPlayer(peerID)
            }
        }
        
        playerTable.isUserInteractionEnabled = true

    }
    
    
    @objc func handleMPCReceivedDataWithNotification(_ notification: Notification) {
        // Get the dictionary containing the data and the source peer from the notification.
        let receivedDataDictionary = notification.object as! Dictionary<String, AnyObject>
        
        // "Extract" the data and the source peer from the received dictionary.
        let data = receivedDataDictionary["data"] as? Data
//        let fromPeer = receivedDataDictionary["fromPeer"] as! MCPeerID
        
        if self.statusType == "Connecting"
        {
        
        // Convert the data (NSData) into a Dictionary object.
        let dataDictionary = NSKeyedUnarchiver.unarchiveObject(with: data!) as! Dictionary<String, Int>
        
        // Check if there's an entry with the "message" key.
        
        OperationQueue.main.addOperation({ () -> Void in

                self.mpDelegate?.startGameForMultipeer(dataDictionary,cObserver: self)
                self.statusType = "Playing"
                self.view.removeFromSuperview()
           
        })

        }
        else
        {
            let dataDictionary = NSKeyedUnarchiver.unarchiveObject(with: data!) as! Dictionary<String, AnyObject>

            OperationQueue.main.addOperation({ () -> Void in
                
                self.mpDelegate?.receivedDataFromOthers(dataDictionary)
                
            })
        }
        
        
    }

}


