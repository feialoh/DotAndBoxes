//
//  GameModel.swift
//  DotSpaceConqueror
//
//  Created by feialoh on 24/11/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class ButtonDetail {
    // MARK: Properties

    var btnId: Int
    var startEnd: (Int, Int)
    var btnActive: Bool
    
    // MARK: Initialization
    
    init?(btnId: Int, startEnd: (Int, Int), btnActive: Bool) {
        // Initialize stored properties.
        self.btnId      = btnId
        self.startEnd   = startEnd
        self.btnActive  = btnActive

    }
    
}


class ViewDetail {
    
    // MARK: Properties
    
    var viewId: Int
    var xy: [(Int,Int)]
    var activeStatus: [Bool]
    var viewDisplay: Bool
    var currentPlayer: MCPeerID
    
    // MARK: Initialization
    
    init?(viewId: Int, xy: [(Int, Int)], activeStatus: [Bool], viewDisplay: Bool, currentPlayer: MCPeerID){
        
        // Initialize stored properties.

        self.viewId         = viewId
        self.xy             = xy
        self.activeStatus   = activeStatus
        self.viewDisplay    = viewDisplay
        self.currentPlayer  = currentPlayer
        
    }
    
}

class PlayerDetail{
    
    var playerID: MCPeerID
    var playerName: String
    var color: [UIColor]!
    var deviceID: String = ""
    var playerReadyStatus: Bool = true
    
    init?(playerID: MCPeerID, playerName: String)
    {
        self.playerID   = playerID
        self.playerName = playerName
        
        var colorArray: [UIColor] = []
        colorArray.append(Utilities.ColorCodeRGB(0xC74A4A))
        colorArray.append(Utilities.ColorCodeRGB(0xFFAE00))
        colorArray.append(Utilities.ColorCodeRGB(0xD44A06))
        colorArray.append(Utilities.ColorCodeRGB(0x485703))
        colorArray.append(Utilities.ColorCodeRGB(0xcc00ff))
        
        self.color = colorArray
    }

}
