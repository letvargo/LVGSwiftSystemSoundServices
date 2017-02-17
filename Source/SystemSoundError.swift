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
 
 */

public enum SystemSoundError: CodedErrorType {
    
    /// The equivalent of `OSStatus` code `kAudioServicesSystemSoundUnspecifiedError`.
    case unspecified(message: String)
    
    /// The equivalent of `OSStatus` code `kAudioServicesBadPropertySizeError`.
    case badPropertySize(message: String)
    
    /// The equivalent of `OSStatus` code `kAudioServicesBadSpecifierSizeError`.
    case badSpecifierSize(message: String)
    
    /// The equivalent of `OSStatus` code `kAudioServicesUnsupportedPropertyError`.
    case unsupportedProperty(message: String)
    
    /// The equivalent of `OSStatus` code `kAudioServicesSystemSoundClientTimedOutError`.
    case clientTimedOut(message: String)
    
    /// Created when the `OSStatus` code is not defined by the System Sound Services API.
    case undefined(code: OSStatus, message: String)
    
    /// Initializes a `SystemSoundError` using a result code
    /// defined by System Sound Services and a message that provides
    /// information about the context from which the error was thrown.
    public init(status: OSStatus, message: String) {
        
        switch status {
            
        case kAudioServicesSystemSoundUnspecifiedError:
            self = .unspecified(message: message)
            
        case kAudioServicesBadPropertySizeError:
            self = .badPropertySize(message: message)
            
        case kAudioServicesBadSpecifierSizeError:
            self = .badSpecifierSize(message: message)
            
        case kAudioServicesUnsupportedPropertyError:
            self = .unsupportedProperty(message: message)
            
        case kAudioServicesSystemSoundClientTimedOutError:
            self = .clientTimedOut(message: message)
            
        default:
            self = .undefined(code: status, message: message)
        }
    }
    
    /// The `OSStatus` result code associated with the error.
    public var code: OSStatus {
        switch self {
        case .unspecified:
            return kAudioServicesSystemSoundUnspecifiedError
        case .badPropertySize:
            return kAudioServicesBadPropertySizeError
        case .badSpecifierSize:
            return kAudioServicesBadSpecifierSizeError
        case .unsupportedProperty:
            return kAudioServicesUnsupportedPropertyError
        case .clientTimedOut:
            return kAudioServicesSystemSoundClientTimedOutError
        case .undefined(let (c, _)):
            return c
        }
    }
    
    /// Returns "System Sound Services Error" for all cases.
    public var domain: String {
        return "System Sound Services Error"
    }
    
    /// A message that provides information about the context from which the error was thrown.
    public var message: String {
        switch self {
        case .unspecified(let m):
            return m
        case .badPropertySize(let m):
            return m
        case .badSpecifierSize(let m):
            return m
        case .unsupportedProperty(let m):
            return m
        case .clientTimedOut(let m):
            return m
        case .undefined(let (_, m)):
            return m
        }
    }
    
    /// A short description of the error.
    public var shortDescription: String {
        switch self {
        case .unspecified:
            return "Unspecified error"
        case .badPropertySize:
            return "Bad property size"
        case .badSpecifierSize:
            return "Bad specifiier size"
        case .unsupportedProperty:
            return "Unsupported property"
        case .clientTimedOut:
            return "Client timed out"
        case .undefined:
            return "This error is not defined by System Sound Services"
        }
    }
}
