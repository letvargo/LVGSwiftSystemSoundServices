//
//  SystemsSound.swift
//  Pods
//
//  Created by doof nugget on 4/24/16.
//
//

import AudioToolbox
import LVGUtilities
 
/// A wrapper around AudioToolbox's SystemSoundID.

open class SystemSound {
    
    // sound is private so only certain SystemSoundType methods can be exposed
    // through SystemSound's public interface.
    fileprivate let sound: SystemSoundID
    
    // Plays the delegate's didFinishPlaying(_:) method.
    fileprivate lazy var systemSoundCompletionProc: AudioServicesSystemSoundCompletionProc = {
        
        _, inClientData in
        
        guard let inClientData = inClientData else { return }
        
        let systemSound: SystemSound = fromPointerConsume(inClientData)
        systemSound.delegate?.didFinishPlaying(systemSound)
    }
    
    /**
     
     Initialize a `SystemSound` using an `NSURL`.
     
     - parameter url: The url of the sound file that will be played.
     
     - throws: `SystemSoundError`
     
     */
    
    // MARK: Initializing a SystemSound
    
    public init(url: URL) throws {
        self.sound = try SystemSoundID(url: url)
    }
    
    // MARK: The delegate property
    
    /**
     
     A `delegate` with a `didFinsishPlaying(_:)` method that is called
     when the system sound finishes playing.
     
     */
    
    open weak var delegate: SystemSoundDelegate? {
        
        didSet {
            
            self.sound.removeCompletion()
            
            if let _ = self.delegate {
                
                do {
                
                    try self.sound.addCompletion(
                        inClientData: UnsafeMutableRawPointer(mutating: toPointerRetain(self)),
                        inCompletionRoutine: systemSoundCompletionProc)
                    
                } catch {
                    
                    print("\(error)")
                }
                
            }
        }
    }
    
    // MARK: Playing Sounds and Alerts
    
    /// Play the system sound assigned to the `soundID` property.
    open func play() {
        self.sound.play()
    }
    
    /**
     
     Play the system sound assigned to the `soundID` property as an alert.
     
     On `iOS` this may cause the device to vibrate. The actual sound played
     is dependent on the device.
     
     On `OS X` this may cause the screen to flash.
     
     */
    
    open func playAsAlert() {
        self.sound.playAsAlert()
    }
    
    #if os(iOS)
    
    /// Cause the phone to vibrate.
    open static func vibrate() {
        SystemSoundID.vibrate()
    }
    
    #endif
    
    #if os(OSX)
    
    /// Play the system-defined alert sound on OS X.
    public static func playSystemAlert() {
        SystemSoundID.playSystemAlert()
    }
    
    /// Flash the screen.
    public static func flashScreen() {
        SystemSoundID.flashScreen()
    }
    
    #endif
    
    // MARK: Working with Properties
    
    /**
     
     Get the value of the `.IsUISound` property.
     
     If `true`, the system sound respects the user setting in the Sound Effects
     preference and the sound will be silent when the user turns off sound effects.
     
     The default value is `true`.
     
     - throws: `SystemSoundError`
     
     - returns: A `Bool` that indicates whether or not the sound will play
     when the user has turned of sound effects in the Sound Effects preferences.
     
     */
    
    open func isUISound() throws -> Bool {
        return try self.sound.isUISound()
    }
    
    /**
     
     Set the value of the `.IsUISound` property.
     
     If `true`, the system sound respects the user setting in the Sound Effects
     preference and the sound will be silent when the user turns off sound effects.
     
     The default value is `true`.
     
     - parameter value: The `Bool` value that is to be set.
     
     - throws: `SystemSoundError`
     
     */
    
    open func isUISound(_ value: Bool) throws {
        try self.sound.isUISound(value)
    }
    
    /**
     
     Get the value of the `.CompletePlaybackIfAppDies` property.
     
     If `true`, the system sound will finish playing even if the application
     dies unexpectedly.
     
     The default value is `true`.
     
     - throws: `SystemSoundError`
     
     */
    
    open func completePlaybackIfAppDies() throws -> Bool {
        return try self.sound.completePlaybackIfAppDies()
    }
    
    /**
     
     Set the value of the `.CompletePlaybackIfAppDies` property.
     
     If `true`, the system sound will finish playing even if the application
     dies unexpectedly.
     
     The default value is `true`.
     
     - parameter value: The `Bool` value that is to be set.
     
     - throws: `SystemSoundError`
     
     */
    
    open func completePlaybackIfAppDies(_ value: Bool) throws {
        try self.sound.completePlaybackIfAppDies(value)
    }
    
    // Dispose of the sound during deinitialization.
    deinit {
        
        do {
            
            try self.sound.dispose()
            
        } catch {
            
            print("\(error)")
        }
    }
}
