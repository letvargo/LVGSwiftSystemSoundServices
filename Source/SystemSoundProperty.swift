//
//  SystemSoundProperty.swift
//  Pods
//
//  Created by doof nugget on 4/24/16.
//
//

import AudioToolbox
import LVGUtilities

// MARK: SystemSoundProperty - Definition

/**
 
 An enum with cases that represent a System Sound Services Property.
 
 Each case has a `code` property equivalent to the `AudioServicesPropertyID`
 that System Sound Services uses to identify properties.
 
 */

public enum SystemSoundProperty: CodedPropertyType {
    
    /// The equivalent of the property code `kAudioServicesPropertyIsUISound`.
    case isUISound
    
    /// The equivalent of the property code `kAudioServicesPropertyCompletePlaybackIfAppDies`.
    case completePlaybackIfAppDies
    
    /// Initializes a `SystemSoundProperty` from an `AudioServicesPropertyID`
    public init?(code: AudioServicesPropertyID) {
        switch code {
        case kAudioServicesPropertyIsUISound:
            self = .isUISound
        case kAudioServicesPropertyCompletePlaybackIfAppDies:
            self = .completePlaybackIfAppDies
        default:
            return nil
        }
    }
    
    /// Returns "System Sound Services Property" for all cases.
    public var domain: String {
        return "System Sound Services Property"
    }
    
    /// The `AudioServicesPropertyID` associated with the property.
    public var code: AudioServicesPropertyID {
        switch self {
        case .isUISound:
            return kAudioServicesPropertyIsUISound
        case .completePlaybackIfAppDies:
            return kAudioServicesPropertyCompletePlaybackIfAppDies
        }
    }
    
    /// A short description of the error.
    public var shortDescription: String {
        switch self {
        case .completePlaybackIfAppDies:
            return "Complete playback if App dies"
        case .isUISound:
            return "Is UI Sound"
        }
    }
}
