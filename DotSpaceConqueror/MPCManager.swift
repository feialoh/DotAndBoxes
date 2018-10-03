//  MPCManager.swift
//  DotSpaceConqueror
//
//  Created by feialoh on 02/12/15.
//  Copyright © 2015 Cabot. All rights reserved.
//
import UIKit
import MultipeerConnectivity


protocol MPCManagerDelegate {
    func foundPeer()
    
    func lostPeer()
    
    func invitationWasReceived(_ fromPeer: String)
    
    func connectedWithPeer(_ peerID: MCPeerID)
}


class MPCManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate {
   

    var delegate: MPCManagerDelegate?
    
    var session: MCSession!
    
    var peer: MCPeerID!
    
    var browser: MCNearbyServiceBrowser!
    
    var advertiser: MCNearbyServiceAdvertiser!
    
    var foundPeers = [MCPeerID]()
    
    var invitationHandler : ((Bool, MCSession)->Void)!
    
    
    override init() {
        super.init()

        //If there is no PeerID save, create one and save it
        if UserDefaults.standard.data(forKey: PEER_ID) == nil
        {
            //Max allowed is 63 characters
            var deviceName = UIDevice.current.name
            var dName = deviceName+"$#$#$-"+DEVICE_ID
            
            if dName.count > 63
            {
                let difference = dName.count - 63
                
                if difference < deviceName.count
                {
                    let offset = deviceName.count - difference
                    let index = deviceName.index(deviceName.startIndex, offsetBy: offset)
                    deviceName = String(deviceName.prefix(upTo: index)).trim()
                    dName = deviceName+"$#$#$-"+DEVICE_ID
                }
                
            }
            
            peer = MCPeerID(displayName:dName )
            
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: peer), forKey: PEER_ID)
        }
        else
        {
            peer = NSKeyedUnarchiver.unarchiveObject(with: UserDefaults.standard.data(forKey: PEER_ID)!) as? MCPeerID
        }
        
        if session == nil
        {
            session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .optional)

        }

        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "dot-game")
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: "dot-game")
        advertiser.delegate = self
    }
    
    
    // MARK: MCNearbyServiceBrowserDelegate method implementation
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        foundPeers.append(peerID)
        
        delegate?.foundPeer()
    }
    

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index, aPeer) in foundPeers.enumerated(){
            if aPeer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
        
        delegate?.lostPeer()
    }
    
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        Utilities.print(error.localizedDescription)
    }
    
    
    // MARK: MCNearbyServiceAdvertiserDelegate method implementation

    @available(iOS 7.0, *)
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        //what do I do here?
        self.invitationHandler = invitationHandler
        
        delegate?.invitationWasReceived(peerID.displayName)
        
    }
    
    /*func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: (@escaping (Bool, MCSession) -> Void))
    {
        
        self.invitationHandler = invitationHandler
        
        delegate?.invitationWasReceived(peerID.displayName)
    }
    */
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        Utilities.print(error.localizedDescription)
    }
    
    
    // MARK: MCSessionDelegate method implementation

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo: [String: AnyObject] = ["peerID":peerID,"state":state.rawValue as AnyObject]
        DispatchQueue.main.async(execute: { () -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "receivedMPCStateNotification"), object: userInfo)
        })
        
    }
    
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo: [String: AnyObject] = ["data": data as AnyObject, "peerID": peerID]
         DispatchQueue.main.async(execute: { () -> Void in
        NotificationCenter.default.post(name: Notification.Name(rawValue: "receivedMPCDataNotification"), object: userInfo)
        })
    }
    
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    
    
    // MARK: Custom method implementation
    
    func sendData(dictionaryWithData dictionary: Dictionary<String, String>, toPeer targetPeer: MCPeerID) -> Bool {
        let dataToSend = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        let peersArray = NSArray(object: targetPeer)
//        var error: NSError?
        

//        if !session.sendData(dataToSend, toPeers: peersArray, withMode: MCSessionSendDataMode.Reliable, error: &error) {
//            Utilities.print(error?.localizedDescription)
//            return false
//        }
        
        do {
            try session?.send(dataToSend, toPeers: peersArray as! [MCPeerID], with: .reliable)
        } catch _ {
            return false
        }
        
        return true
    }
    
}

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
