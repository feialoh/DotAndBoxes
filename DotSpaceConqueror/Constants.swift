//
//  Constants.swift
//  DotSpaceConqueror
//
//  Created by feialoh on 4/13/15.
//  Copyright (c) 2015 cabot. All rights reserved.
//

import UIKit



// Alerts

let APP_NAME                        = "DotSpaceConqueror"


// MARK : - APP Constants

let PLAY_GAME                                   = "Play Game"
let NO_DOTS                                     = "Choose No of Dots"
let NO_PLAYERS                                  = "Choose No of Players"
let SETTINGS                                    = "Settings"
let HELP                                        = "Help"
let SOUND                                       = "Sounds"
let PROFILE_PIC                                 = "ProfilePic"
let PEER_ID                                     = "PeerID"
let SESSION_ID                                  = "SessionID"

//MARK:- Segue identifiers

let MAINGAME_VC_SEGUE                           = "startToGame"

let MULTIPEER_VC_SEGUE                          = "toMultipeerView"

let MULTITOMAIN_VC_SEGUE                        = "multiToMainGame"


//MARK:- NavigationBar constants

let NAVBAR_HEIGHT : CGFloat                             = 44.0
let NAVBAR_BUTTON_WIDTH : CGFloat                       = 40.0
let MAX_PLAYERS : Int                                   = 7
let MARGIN:CGFloat                                      = IS_IPAD ? 50.0:10.0

//MARK:- HELP constants

let GAME_RULES = "Players take turns joining two horizontally or vertically adjacent dots by a line. A player that completes the fourth side of a square (a box) colors that box and must play again. When all boxes have been colored, the game ends and the player who has colored more boxes wins."

let MP_RULES = "Multiplayer currently supports upto 5 players on same and different devices, while playing multiplayer on different device, make sure that you wait for all the players to connect before clicking on start button or the players joined later will not get connected. The player chance is currently in alphabetical order and the player to start first should wait for the other players to join the main game screen before start."

let IS_IPAD = (UIDevice.current.userInterfaceIdiom == .pad)

let FONT_SIZE:CGFloat = IS_IPAD ? 30.0 : 16.0

let DEVICE_ID           = UIDevice.current.identifierForVendor!.uuidString
