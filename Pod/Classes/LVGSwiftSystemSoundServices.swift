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

 Any object that adopts the `SystemSoundType` protocol will be able to play system
 sound files associated with its `soundID` property.
 
 **Required properties:**
 
 `var soundID: SystemSoundID { get }`
 
 **Default method implementations:**
 
 `public static func open(url: NSURL) throws -> SystemSoundID`
 
 Associates the sound file at the specified url with the returned `SystemSoundID`.

*/

public protocol SystemSoundType {
    var soundID: SystemSoundID { get }
}

// MARK: SystemSoundType - Default method implementations

extension SystemSoundType {

    /** 
    
     Allows `SystemSoundType.Error` to be used as a typealias
     for `SystemSoundError`.
    
    */
    
    // Internally, Error can be used as a shortname for SystemSoundError
    
    public typealias Error = SystemSoundError
    
    /**
    
    Associates the sound file at the specified url with the returned `SystemSoundID`.
    
    - parameter url: The `NSURL` where the sound file is located.
    - throws: `SystemSoundError`
    
    */
    
    public static func open(url: NSURL) throws -> SystemSoundID {
        
        var soundID = SystemSoundID.max
        
        try Error.check(
            AudioServicesCreateSystemSoundID(url, &soundID),
            message: "An error occurred while trying to associate the sound file at url \(url) with a SystemSoundID.")
        
        return soundID
    }
    
    /**
     
     Dispose of the system sound assigned to the `soundID` property.
     
     */
    
    public func dispose() throws {
        try Error.check(
            AudioServicesDisposeSystemSoundID(self.soundID),
            message: "An error occurred while disposing of the SystemSoundID." )
    }
    
    /**
     
     Play the system sound assigned to the `soundID` property.
     
     */
    
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
    
    #if os(OSX)
    
        /**
     
         A class function for playing the system-defined alert sound on OS X.
     
         */
    
        static public func playSystemAlert() {
            AudioServicesPlayAlertSound(kSystemSoundID_UserPreferredAlert)
        }
    
    #endif
    
    /**
     
     Adds a completion handler that will be called when the `SystemSound`
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
        inRunLoop: CFRunLoop? = nil,
        inRunLoopMode: String? = nil,
        inClientData: UnsafeMutablePointer<Void> = nil,
        inCompletionRoutine: AudioServicesSystemSoundCompletionProc) throws {
        
        self.removeCompletion()
        
        try Error.check(
            AudioServicesAddSystemSoundCompletion(
                self.soundID,
                inRunLoop,
                inRunLoopMode,
                inCompletionRoutine,
                inClientData ),
            message: "An error occurred while adding a completion handler to system sound." )
        
    }
    
    /**
     
     Remove any completion handler that may be assigned to the `SystemSoundID`.
     
     */
    
    public func removeCompletion() {
        AudioServicesRemoveSystemSoundCompletion(self.soundID)
    }
}

// MARK: SystemSoundError - Definition

/**

 An enum with cases that represent the result codes defined by System Sound Services.
 
 Each case has a `code` property equivalent to the result code for the
 corresponding error defined by System Sound Services.
 
 Each case also has an associated value of type `String` that can be accessed
 using the value's `message` property. This is used to provide information about
 the context from which the error was thrown.
 
 **Cases and code values:**
 
 `case Unspecified(message: String) = kAudioServicesSystemSoundUnspecifiedError`
 
 `case BadPropertySize(message: String) = kAudioServicesBadPropertySizeError`
 
 `case BadSpecifierSize(message: String) = kAudioServicesBadSpecifierSizeError`
 
 `case UnsupportedProperty(message: String) = kAudioServicesUnsupportedPropertyError`
 
 `case ClientTimedOut(message: String) = kAudioServicesSystemSoundClientTimedOutError`
 
 `case Undefined(status: OSStatus, message: String) = <Result code not defined by System Sound Services>`
 
 **Properties:**
 
 `var domain: String { get }`
 
 Returns "System Sound Services Error" for all cases.
 
 `var shortDescription: String { get }`
 
 A short description of the error.
 
 `var message: String { get }`
 
 A message that provides information about the context from which the error was thrown.
 
 `var code: OSSstatus { get }`
 
 `var description: String { get }`
 
 A formatted `String` description of the error. Required by `CustomStringRepresentable`.
 
 The result code associated with the error.
 
 **Initializers:**
 
 `public init(status: OSStatus, message: String)`
 
 **Conforms to:**
 
 `CodedErrorType`

*/

public enum SystemSoundError: CodedErrorType {
    
    case Unspecified(message: String)
    case BadPropertySize(message: String)
    case BadSpecifierSize(message: String)
    case UnsupportedProperty(message: String)
    case ClientTimedOut(message: String)
    case Undefined(code: OSStatus, message: String)
    
    
    /// Returns "System Sound Services Error" for all cases.
    
    public var domain: String {
        return "System Sound Services Error"
    }
    
    /// A short description of the error.
    
    public var shortDescription: String {
        switch self {
        case .Unspecified:
            return "Unspecified error"
        case .BadPropertySize:
            return "Bad property size"
        case .BadSpecifierSize:
            return "Bad specifiier size"
        case .UnsupportedProperty:
            return "Unsupported property"
        case .ClientTimedOut:
            return "Client timed out"
        case .Undefined:
            return "This error is not defined by System Sound Services"
        }
    }
    
    /// The result code associated with the error.
    
    public var code: OSStatus {
        switch self {
        case .Unspecified:
            return kAudioServicesSystemSoundUnspecifiedError
        case .BadPropertySize:
            return kAudioServicesBadPropertySizeError
        case .BadSpecifierSize:
            return kAudioServicesBadSpecifierSizeError
        case .UnsupportedProperty:
            return kAudioServicesUnsupportedPropertyError
        case .ClientTimedOut:
            return kAudioServicesSystemSoundClientTimedOutError
        case .Undefined(let (c, _)):
            return c
        }
    }
    
    /// A message that provides information about the context from which the error was thrown.
    
    public var message: String {
        switch self {
        case .Unspecified(let m):
            return m
        case .BadPropertySize(let m):
            return m
        case .BadSpecifierSize(let m):
            return m
        case .UnsupportedProperty(let m):
            return m
        case .ClientTimedOut(let m):
            return m
        case .Undefined(let (_, m)):
            return m
        }
    }
    
    /// Initializes a `SystemSoundError` using a result code
    /// defined by System Sound Services and a message that provides
    /// information about the context from which the error was thrown.
    
    public init(status: OSStatus, message: String) {
        
        switch status {
            
        case kAudioServicesSystemSoundUnspecifiedError:
            self = .Unspecified(message: message)
            
        case kAudioServicesBadPropertySizeError:
            self = .BadPropertySize(message: message)
            
        case kAudioServicesBadSpecifierSizeError:
            self = .BadSpecifierSize(message: message)
            
        case kAudioServicesUnsupportedPropertyError:
            self = .UnsupportedProperty(message: message)
            
        case kAudioServicesSystemSoundClientTimedOutError:
            self = .ClientTimedOut(message: message)
            
        default:
            self = .Undefined(code: status, message: message)
        }
    }
}

// MARK: SystemSoundProperty - Definition

/**
 
 An enum with cases that represent a System Sound Services Property.
 
 Each case has a `code` property equivalent to the `AudioServicesPropertyID`
 that System Sound Services uses to identify properties.
 
 **Cases and code values:**
 
 `case IsUISound = kAudioServicesPropertyIsUISound`
 
 `case CompletePlaybackIfAppDies = kAudioServicesPropertyCompletePlaybackIfAppDies`
 
 **Properties:**
 
 `var domain: String { get }`
 
 Returns "System Sound Services Property" for all cases.
 
 `var shortDescription: String { get }`
 
 A short description of the property.
 
 `var description: String { get }`
 
 A formatted `String` description of the property. Required by `CustomStringRepresentable`.
 
 `var code: AudioServicesPropertyID { get }`
 
 The `AudioServicesPropertyID` associated with the property.
 
 **Conforms to:**
 
 `CodedPropertyType`
 
 */

public enum SystemSoundProperty: CodedPropertyType {
    
    case IsUISound
    case CompletePlaybackIfAppDies
    
    /// Returns "System Sound Services Property" for all cases.
    
    public var domain: String {
        return "System Sound Services Property"
    }
    
    /// A short description of the error.
    
    public var shortDescription: String {
        switch self {
        case .CompletePlaybackIfAppDies:
            return "Complete playback if App dies"
        case .IsUISound:
            return "Is UI Sound"
        }
    }
    
    /// The `AudioServicesPropertyID` associated with the property.
    
    public var code: AudioServicesPropertyID {
        switch self {
        case .IsUISound:
            return kAudioServicesPropertyIsUISound
        case .CompletePlaybackIfAppDies:
            return kAudioServicesPropertyCompletePlaybackIfAppDies
        }
    }
    
    /// Initializes a `SystemSoundProperty` from an `AudioServicesPropertyID`
    
    public init?(code: AudioServicesPropertyID) {
        switch code {
        case kAudioServicesPropertyIsUISound:
            self = .IsUISound
        case kAudioServicesPropertyCompletePlaybackIfAppDies:
            self = .CompletePlaybackIfAppDies
        default:
            return nil
        }
    }
}

// MARK: SystemSoundType - Property getters and setters

extension SystemSoundType {

    public typealias PropertyInfo = (size: UInt32, writable: Bool)
    
    /**
     
     Gets the property info for the property.
     
     - parameter property: The property to check.
     
     - returns: `PropertyInfo` - a `(size: UInt32, writable: Bool)` tuple
     
     - throws: `SystemSoundError`
     
     */
    
    public func propertyInfo(property: SystemSoundProperty) throws -> PropertyInfo {
        var size: UInt32 = UInt32.max
        var writable: DarwinBoolean = false
        
        try Error.check(
            AudioServicesGetPropertyInfo(
                property.code,
                UInt32(sizeofValue(self.soundID)),
                [self.soundID],
                &size,
                &writable),
            message: "An error occurred while getting the property info for property '\(property.shortDescription)'.")
        
        return (size, Bool(writable))
    }
    
    /**
     
     Obtains the size of the property.
     
     This is the equivalent of calling `self.propertyInfo(property).size`
     
     - parameter property: The property to check.
     
     - returns: `UInt32`
     
     - throws: `SystemSoundError`
     
     */
    
    public func propertySize(property: SystemSoundProperty) throws -> UInt32 {
        return try self.propertyInfo(property).size
    }
    
    /**
    
     Checks to see if the property is writable.
     
     This is the equivalent of calling `self.propertyInfo(property).writable`
     
     - parameter property: The property to check.
     
     - returns: `Bool`
     
     - throws: `SystemSoundError`
    
    */
    
    public func propertyIsWritable(property: SystemSoundProperty) throws -> Bool {
        return try self.propertyInfo(property).writable
    }
    
    /**
     
     Gets the value of the `.IsUISound` property.
     
     If `true`, the system sound respects the user setting in the Sound Effects
     preference and the sound will be silent when the user turns off sound effects.
     
     The default value is `true`.
     
     - throws: `SystemSoundError`
     
     - returns: A `Bool` that indicates whether or not the sound will play
     when the user has turned of sound effects in the Sound Effects preferences.
     
     */
    
    public func isUISound() throws -> Bool {
        
        let specifierSize = UInt32(sizeofValue(self.soundID))
        
        var size = try self.propertySize(.IsUISound)
        var result: UInt32 = 0
        
        try Error.check(
            AudioServicesGetProperty(
                SystemSoundProperty.IsUISound.code,
                specifierSize,
                [self.soundID],
                &size,
                &result ),
            message: "An error occurred while getting the 'isUISound' property.")
        
        return result == 1
    }
    
    /**
    
     Sets the value of the `.IsUISound` property.
     
     If `true`, the system sound respects the user setting in the Sound Effects
     preference and the sound will be silent when the user turns off sound effects.
     
     The default value is `true`.
     
     - parameter value: The `Bool` value that is to be set.
     
     - throws: `SystemSoundError`
    
    */
    
    public func isUISound(value: Bool) throws {
        
        let specifierSize = UInt32(sizeofValue(self.soundID))
        
        let size = try self.propertySize(.IsUISound)
        let isUISound: UInt32 = value ? 1 : 0
        
        try Error.check(
            AudioServicesSetProperty(
                SystemSoundProperty.IsUISound.code,
                specifierSize,
                [self.soundID],
                size,
                [isUISound] ),
            message: "An error occurred while setting the 'isUISound' property.")
    }
    
    /**
     
     Gets the value of the `.CompletePlaybackIfAppDies` property.
     
     If `true`, the system sound will finish playing even if the application
     dies unexpectedly.
     
     The default value is `true`.
     
     - throws: `SystemSoundError`
     
     */
    
    public func completePlaybackIfAppDies() throws -> Bool {
        
        let specifierSize = UInt32(sizeofValue(self.soundID))
        
        var size = try self.propertySize(.CompletePlaybackIfAppDies)
        var result: UInt32 = 0
        
        try Error.check(
            AudioServicesGetProperty(
                SystemSoundProperty.CompletePlaybackIfAppDies.code,
                specifierSize,
                [self.soundID],
                &size,
                &result ),
            message: "An error occurred while getting the 'completePlaybackIfAppDies' property.")
        
        return result == 1
    }
    
    /**
     
     Sets the value of the `.CompletePlaybackIfAppDies` property.
     
     If `true`, the system sound will finish playing even if the application
     dies unexpectedly.
     
     The default value is `true`.
     
     - parameter value: The `Bool` value that is to be set.
     
     - throws: `SystemSoundError`
     
     */
    
    public func completePlaybackIfAppDies(value: Bool) throws {
        
        let specifierSize = UInt32(sizeofValue(self.soundID))
        
        let size = try self.propertySize(.CompletePlaybackIfAppDies)
        let completePlayback: UInt32 = value ? 1 : 0
        
        try Error.check(
            AudioServicesSetProperty(
                SystemSoundProperty.CompletePlaybackIfAppDies.code,
                specifierSize,
                [self.soundID],
                size,
                [completePlayback] ),
            message: "An error occurred while setting the 'completePlaybackIfAppDies' property.")
    }
}

public protocol SystemSoundDelegate: class {
    func didFinishPlaying(sound: SystemSound)
}

/**
 
 A wrapper around AudioToolbox's SystemSoundID
 
 **Conforms To:**
 
 `SystemSoundType`
 
 */

public class SystemSound: SystemSoundType {
    
    /**
     
     A property for storying the `SystemSoundID`.
     
     */
    
    public let soundID: SystemSoundID
    
    private lazy var systemSoundCompletionProc: AudioServicesSystemSoundCompletionProc = {
        
        _, inClientData in
        
        let systemSound: SystemSound = bridgeTransfer(inClientData)
        systemSound.delegate?.didFinishPlaying(systemSound)
    }
    
    /**
     
     A `delegate` with a `didFinsishPlaying(_:)` function that is called
     when the system sound finishes playing.
     
     - Important: Setting this property changes the completion handler
     that is assigned to the `SystemSoundID`. Likewise, adding a
     completion handler manually using
     `addCompletion(inClientData:inCompletionRoutine:)` can result in
     resetting the delegate property to `nil`. The following rules
     define the relationship between the delegate property and the
     completion handler:
     
     1. Setting this property to a `SystemDoundDelegate` object
     removes any completion handler previously assigned to the
     `SystemSoundID`.
     2. Setting this property to `nil` removes any completion handler
     previously assigned to the `SystemSoundID`.
     3. Adding a completion handler using
     `addCompletion(inClientData:inCompletionRoutine:)` will cause the
     `delegate` property to be set to `nil`.
     4. Removing a completion handler using `removeCompletion()` will cause
     the `delegate` property to be set to `nil`.
     
     */
    
    public weak var delegate: SystemSoundDelegate? {
        
        didSet {
            
            do {
                
                try self.addCompletion(
                    inClientData: UnsafeMutablePointer(bridgeRetained(self)),
                    inCompletionRoutine: self.systemSoundCompletionProc )
                
            } catch {
                
                print("\(error)")
            }
        }
        
        willSet {
            
            if newValue == nil {
                
                self.removeCompletion()
            }
        }
    }
    
    /**
     
     Initialize a `SystemSound` object using an `NSURL`.
     
     - parameter url: The url of the sound file that will be played.
     
     - throws: `SystemSoundError`
     
     */
    
    public init(url: NSURL) throws {
        self.soundID = try SystemSound.open(url)
    }
    
    /**
     
     Adds a completion handler that will be called when the `SystemSound`
     finishes playing.
     
     - important: This method also has the effect of setting the `delegate`
     property to `nil`.
     
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
        inRunLoop: CFRunLoop? = nil,
        inRunLoopMode: String? = nil,
        inClientData: UnsafeMutablePointer<Void> = nil,
        inCompletionRoutine: AudioServicesSystemSoundCompletionProc) throws {
        
        self.removeCompletion()
        
        try Error.check(
            AudioServicesAddSystemSoundCompletion(
                self.soundID,
                inRunLoop,
                inRunLoopMode,
                inCompletionRoutine,
                inClientData ),
            message: "An error occurred while adding a completion handler to system sound." )
        
    }
    
    /**
     
     Remove any completion handler that may be assigned to the `SystemSoundID`.
     
     - Important: This method also has the effect of setting the `delegate`
     property to `nil`.
     
     */
    
    public func removeCompletion() {
        self.delegate = nil
        AudioServicesRemoveSystemSoundCompletion(self.soundID)
    }
    
    deinit {
        
        do {
            
            try self.dispose()
            
        } catch {
            
            print("\(error)")
        }
    }
}