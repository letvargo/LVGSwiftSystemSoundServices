//
//  LVGSwiftSystemSoundServices.swift
//  Pods
//
//  Created by Aaron Rasmussen on 4/14/16.
//
//

import AudioToolbox

// MARK: SystemSoundType - Definition

/**

 Any object that conforms to the `SystemSoundType` protocol will be able to 
 play system sound files associated with its `soundID` property.
 
 To conform any object to the `SystemSoundType` protocol give it a property
 called `soundID` of type `UInt32`.
     
 Before playing the sound you have to associate the `soundID` property with
 an audio file. This can be done using the `SystemSoundID` convenience
 initializer `SystemSoundID(url: NSURL) throws`.
 
 The following code is an example of one way to declare an object that
 conforms to `SystemSoundType`:
 
     struct MySystemSound: SystemSoundType {
         let soundID: SystemSoundID
         
         init(url: NSURL) -> throws {
             self.soundID = try SystemSoundID(url: url)
         }
     }
 */

public protocol SystemSoundType {
    
    /// A `SystemSoundID` that can be associated with an audio file.
    var soundID: SystemSoundID { get }
}

// MARK: SystemSoundType - Default method implementations

extension SystemSoundType {
    
    /// Dispose of the system sound assigned to the `soundID` property.
    public func dispose() throws {
        try Error.check(
            AudioServicesDisposeSystemSoundID(self.soundID),
            message: "An error occurred while disposing of the SystemSoundID." )
    }
    
    /**
     
     Add a completion handler that will be called when the `SystemSound`
     finishes playing.
     
     - important: This method removes any previously assigned completion handler.
     
     - parameters:
     - inRunLoop: The run-loop where the completion handler will be executed.
     If this property is set to `nil`, the completion handler will be executed
     in the current run-loop. The default value is `nil`.
     - inRunLoopMode: The run-loop mode. Leave this property set to `nil` to
     use the default run-loop mode. The default value is `nil`.
     - inClientData: A pointer to a user-defined data object that is passed
     to the completion handler for use during its execution.
     - inCompletionRoutine: The completion handler.
     - throws: `SystemSoundError`
     
     */
    
    public func addCompletion(
        _ inRunLoop: RunLoop? = nil,
        inRunLoopMode: String? = nil,
        inClientData: UnsafeMutableRawPointer? = nil,
        inCompletionRoutine: @escaping AudioServicesSystemSoundCompletionProc) throws {
        
        self.removeCompletion()
        
        try Error.check(
            AudioServicesAddSystemSoundCompletion(
                self.soundID,
                inRunLoop?.getCFRunLoop(),
                inRunLoopMode as CFString?,
                inCompletionRoutine,
                inClientData ),
            message: "An error occurred while adding a completion handler to system sound." )
    }
    
     /// Remove the completion handler.
    public func removeCompletion() {
        AudioServicesRemoveSystemSoundCompletion(self.soundID)
    }
    
    /// Play the system sound assigned to the `soundID` property.
    public func play() {
        AudioServicesPlaySystemSound(self.soundID)
    }
    
    /**
     
     Play the system sound assigned to the `soundID` property as an alert.
     
     On `iOS` this may cause the device to vibrate. The actual sound played
     is dependent on the device.
     
     On `OS X` this may cause the screen to flash.
     
     */
    
    public func playAsAlert() {
        AudioServicesPlayAlertSound(self.soundID)
    }
    
    #if os(iOS)
    
    /// Cause the phone to vibrate.
    public static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    #endif
    
    #if os(OSX)
    
    /// Play the system-defined alert sound on OS X.
    public static func playSystemAlert() {
        AudioServicesPlayAlertSound(kSystemSoundID_UserPreferredAlert)
    }
    
    /// Flash the screen.
    public static func flashScreen() {
        AudioServicesPlayAlertSound(kSystemSoundID_FlashScreen)
    }
    
    #endif
}

// MARK: SystemSoundType - Property getters and setters

extension SystemSoundType {
    
    public typealias PropertyInfo = (size: UInt32, writable: Bool)
    
    /**
     
     Gets the property info for the property.
     
     Note that the returned `PropertyInfo` value is a tuple of type
     `(size: UInt32, writable: Bool)`.
     
     - parameter property: The property to check.
     
     - returns: `PropertyInfo`
     
     - throws: `SystemSoundError`
     
     */
    
    public func propertyInfo(_ property: SystemSoundProperty) throws -> PropertyInfo {
        var size: UInt32 = UInt32.max
        var writable: DarwinBoolean = false
        
        try Error.check(
            AudioServicesGetPropertyInfo(
                property.code,
                UInt32(MemoryLayout.size(ofValue: self.soundID)),
                [self.soundID],
                &size,
                &writable),
            message: "An error occurred while getting the property info for property '\(property.shortDescription)'.")
        
        return (size, writable == true)
    }
    
    /**
     
     Obtain the size of the property.
     
     This is the equivalent of calling `self.propertyInfo(property).size`
     
     - parameter property: The property to check.
     
     - returns: `UInt32`
     
     - throws: `SystemSoundError`
     
     */
    
    public func propertySize(_ property: SystemSoundProperty) throws -> UInt32 {
        return try self.propertyInfo(property).size
    }
    
    /**
     
     Check to see if the property is writable.
     
     This is the equivalent of calling `self.propertyInfo(property).writable`
     
     - parameter property: The property to check.
     
     - returns: `Bool`
     
     - throws: `SystemSoundError`
     
     */
    
    public func propertyIsWritable(_ property: SystemSoundProperty) throws -> Bool {
        return try self.propertyInfo(property).writable
    }
    
    /**
     
     Get the value of the `.IsUISound` property.
     
     If `true`, the system sound respects the user setting in the Sound Effects
     preference and the sound will be silent when the user turns off sound effects.
     
     The default value is `true`.
     
     - throws: `SystemSoundError`
     
     - returns: A `Bool` that indicates whether or not the sound will play
     when the user has turned of sound effects in the Sound Effects preferences.
     
     */
    
    public func isUISound() throws -> Bool {
        
        let specifierSize = UInt32(MemoryLayout.size(ofValue: self.soundID))
        
        var size = try self.propertySize(.isUISound)
        var result: UInt32 = 0
        
        try Error.check(
            AudioServicesGetProperty(
                SystemSoundProperty.isUISound.code,
                specifierSize,
                [self.soundID],
                &size,
                &result ),
            message: "An error occurred while getting the 'isUISound' property.")
        
        return result == 1
    }
    
    /**
     
     Set the value of the `.IsUISound` property.
     
     If `true`, the system sound respects the user setting in the Sound Effects
     preference and the sound will be silent when the user turns off sound effects.
     
     The default value is `true`.
     
     - parameter value: The `Bool` value that is to be set.
     
     - throws: `SystemSoundError`
     
     */
    
    public func isUISound(_ value: Bool) throws {
        
        let specifierSize = UInt32(MemoryLayout.size(ofValue: self.soundID))
        
        let size = try self.propertySize(.isUISound)
        let isUISound: UInt32 = value ? 1 : 0
        
        try Error.check(
            AudioServicesSetProperty(
                SystemSoundProperty.isUISound.code,
                specifierSize,
                [self.soundID],
                size,
                [isUISound] ),
            message: "An error occurred while setting the 'isUISound' property.")
    }
    
    /**
     
     Get the value of the `.CompletePlaybackIfAppDies` property.
     
     If `true`, the system sound will finish playing even if the application
     dies unexpectedly.
     
     The default value is `true`.
     
     - throws: `SystemSoundError`
     
     */
    
    public func completePlaybackIfAppDies() throws -> Bool {
        
        let specifierSize = UInt32(MemoryLayout.size(ofValue: self.soundID))
        
        var size = try self.propertySize(.completePlaybackIfAppDies)
        var result: UInt32 = 0
        
        try Error.check(
            AudioServicesGetProperty(
                SystemSoundProperty.completePlaybackIfAppDies.code,
                specifierSize,
                [self.soundID],
                &size,
                &result ),
            message: "An error occurred while getting the 'completePlaybackIfAppDies' property.")
        
        return result == 1
    }
    
    /**
     
     Set the value of the `.CompletePlaybackIfAppDies` property.
     
     If `true`, the system sound will finish playing even if the application
     dies unexpectedly.
     
     The default value is `true`.
     
     - parameter value: The `Bool` value that is to be set.
     
     - throws: `SystemSoundError`
     
     */
    
    public func completePlaybackIfAppDies(_ value: Bool) throws {
        
        let specifierSize = UInt32(MemoryLayout.size(ofValue: self.soundID))
        
        let size = try self.propertySize(.completePlaybackIfAppDies)
        let completePlayback: UInt32 = value ? 1 : 0
        
        try Error.check(
            AudioServicesSetProperty(
                SystemSoundProperty.completePlaybackIfAppDies.code,
                specifierSize,
                [self.soundID],
                size,
                [completePlayback] ),
            message: "An error occurred while setting the 'completePlaybackIfAppDies' property.")
    }
}
