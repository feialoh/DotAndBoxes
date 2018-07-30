//
//  MenuItems.swift
//  SlideOutNavigation
//
//  Created by feialoh on 19/10/15.
//  Copyright © 2015 Cabot. All rights reserved.
//

import UIKit


class MenuItems {
  
  let title: String
  let image: UIImage?
  
  init(title: String, image: UIImage?) {
    self.title = title
    self.image = image
  }
  
  class func allMenu() -> Array<MenuItems> {
    return [ MenuItems(title: PLAY_GAME, image: UIImage(named: "game")),
      MenuItems(title: NO_DOTS, image: UIImage(named: "dots")),
      MenuItems(title: NO_PLAYERS, image: UIImage(named: "player")),
      MenuItems(title: SETTINGS, image: UIImage(named: "settings")),
      MenuItems(title: HELP, image: UIImage(named: "help")),
      MenuItems(title: SOUND, image: UIImage(named: "soundOn")) ]
  }
  
 }


class SoundMenuItems {
    
    let title: String
    let artist: String
    let copyright: String
    
    init(title: String, artist: String, copyright: String) {
        self.title = title
        self.artist = artist
        self.copyright = copyright
    }
    
    class func allSoundMenu() -> Array<SoundMenuItems> {
        
        let copyRight = "Coyright (c) 2015 Licensed under a Creative Commons Attribution Noncommercial  (3.0) license. "
        
        return [ SoundMenuItems(title: "1033_onlymeith", artist:"Meith", copyright: copyRight + "http://ccmixter.org/files/onlymeith/52169"),
            SoundMenuItems(title: "80s_Space_Game_Loop_Eric", artist:"Eric Matyas", copyright: copyRight + "http://www.soundimage.org"),
            SoundMenuItems(title: "Carosene_Cdk", artist:"CDK", copyright: copyRight + "http://ccmixter.org/files/cdk/52193"),
            SoundMenuItems(title: "Macros_Theme_LoveShadow", artist:"LoveShadow", copyright: copyRight + "http://ccmixter.org/files/Loveshadow/52221"),
            SoundMenuItems(title: "Motherlode_Kevin", artist:"Kevin MacLeod", copyright: copyRight + "http://creativecommons.org/licenses/by/3.0/"),
            SoundMenuItems(title: "Triumph_Of_Clock_Master_Eric", artist:"Eric Matyas", copyright: copyRight+"http://www.soundimage.org"),
            SoundMenuItems(title: "What_is_Love_Kevin", artist:"Kevin MacLeod", copyright: copyRight+"http://creativecommons.org/licenses/by/3.0/")]
    }
    
}
