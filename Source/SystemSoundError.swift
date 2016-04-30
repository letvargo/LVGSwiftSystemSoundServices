//
//  SystemSoundError.swift
//  Pods
//
//  Created by doof nugget on 4/24/16.
//
//

import AudioToolbox
import LVGUtilities

// Internally, Error can be used as a shortname for SystemSoundError
typealias Error = SystemSoundError

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