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