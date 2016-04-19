//
//  AudioUtil.swift
//  MeeDocChatClient
//
//  Created by Karim Ihab on 4/19/16.
//  Copyright © 2016 Karim Ihab. All rights reserved.
//

import Foundation
import AVFoundation

class AudioUtil {

    static var receivedMessageAudio = AVAudioPlayer()
    static var sentMessageAudio = AVAudioPlayer()

    static func prepareAudio() {
        prepareAudioForPlay(&sentMessageAudio, audioName: "sentMessageAudio")
        prepareAudioForPlay(&receivedMessageAudio, audioName: "receivedMessageAudio")
    }
    
    
    static func prepareAudioForPlay(inout audio: AVAudioPlayer, audioName: String) {
        
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(audioName, ofType: "mp3")!)
        
        do {
            // Removed deprecated use of AVAudioSessionDelegate protocol
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            let _:NSError?
            
            audio = try AVAudioPlayer(contentsOfURL: alertSound)
            audio.prepareToPlay()
        } catch _ {
        }
    }
    
    
}