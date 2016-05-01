//
//  SystemSoundID_Extension.swift
//  Pods
//
//  Created by doof nugget on 4/30/16.
//
//

import AudioToolbox

public typealias SystemSoundID = UInt32

extension SystemSoundID {
    
    /// Initialize a `SystemSoundID` associated with the audio file at `url`.
    public init(url: NSURL) throws {
        
        var soundID = SystemSoundID.max
        
        try SystemSoundError.check(
            AudioServicesCreateSystemSoundID(url, &soundID),
            message: "An error occurred while trying to associate the sound file at url \(url) with a SystemSoundID.")
        
        self.init(soundID)
    }
}

extension SystemSoundID: SystemSoundType {

    public var soundID: SystemSoundID {
        return self
    }
}