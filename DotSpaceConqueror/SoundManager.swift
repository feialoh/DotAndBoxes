//
//  SoundManager.swift
//  DotSpaceConqueror
//
//  Created by Feialoh Francis on 8/1/18.
//  Copyright © 2018 Cabot. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate
{
    static let sharedInstance = SoundManager()
    
    var audioPlayer: AVAudioPlayer?
    
    func playSong(fileName: String, fileType: String,volume:Float){
        
        guard let audioFilePath = Bundle.main.path(forResource: fileName, ofType: fileType) else { return }
        
        let audioFileUrl = URL(fileURLWithPath: audioFilePath)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl, fileTypeHint: nil)
            
            guard let player = audioPlayer else { return }
            
            player.numberOfLoops = -1
            player.prepareToPlay()
            player.volume = volume
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
   
}

//    func playSong(fileName: String, fileType: String,volume:Float){
//
//        do
//        {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//
//            let audioFilePath = Bundle.main.path(forResource: fileName, ofType: fileType)
//            if audioFilePath != nil {
//                let audioFileUrl = URL(fileURLWithPath: audioFilePath!)
//                try! audioPlayer = AVAudioPlayer(contentsOf: audioFileUrl, fileTypeHint: nil)
//                audioPlayer?.numberOfLoops = -1
//                audioPlayer?.prepareToPlay()
//                audioPlayer?.volume = volume
//                audioPlayer?.play()
//            } else {
//                Utilities.print("audio file is not found")
//            }
//        }
//        catch let error {
//            print(error.localizedDescription)
//        }
//
//}

