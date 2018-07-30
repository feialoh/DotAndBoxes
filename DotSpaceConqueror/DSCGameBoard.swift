//
//  DSCGameBoard.swift
//  DotSpaceConqueror
//
//  Created by Feialoh Francis on 11/2/16.
//  Copyright © 2016 Cabot. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit


class DSCGameBoard:NSObject,GKGameModel{
    /**
     * Array of instances of GKGameModelPlayers representing players within this game model. When the 
     * GKMinmaxStrategist class is used to find an optimal move for a specific player, it uses this 
     * array to rate the moves of that player’s opponent(s).
     */

    //MARK: - Managing players
    
    var players: [GKGameModelPlayer]?
    var activePlayer: GKGameModelPlayer?
    
    var currentPlayer: DSCPlayer!
    
 
    
    override init()
    {
        super.init()
    }
    
    //MARK: - Copying board state
    
    func copy(with zone: NSZone?) -> Any {
        let copy = DSCGameBoard()
        copy.setGameModel(self)
        return copy
    }
    
    func setGameModel(_ gameModel: GKGameModel) {
        let model = gameModel as! DSCGameBoard
//        self.updateLineFromBoard(model)
        self.currentPlayer = model.currentPlayer
    }
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        
        return [GKGameModelUpdate]()
    }
    
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        
    }
    
}
