//
//  SystemSoundTypeTests.swift
//  LVGSwiftSystemSoundServices
//
//  Created by doof nugget on 4/15/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import LVGSwiftSystemSoundServices
import LVGUtilities
import AudioToolbox

class SystemSoundTypeTests: XCTestCase {

    struct ClientData {
        var expectation: XCTestExpectation
        var wasCalled = false
        
        init(_ expectation: XCTestExpectation) {
            self.expectation = expectation
        }
    }
    
    let callback: AudioServicesSystemSoundCompletionProc = { ssID, inClientData in
        var data = UnsafeMutablePointer<ClientData>(inClientData)
        data.pointee.wasCalled = true
        data.pointee.expectation.fulfill()
    }
    
    let frog = URL(fileURLWithPath: "/System/Library/Sounds/Frog.aiff")
    
    var sound: SystemSoundID!
    
    override func setUp() {
        self.sound = try? SystemSoundID(url: frog)
    }
    
    override func tearDown() {
        try! self.sound.dispose()
        self.sound = nil
    }

    func testOpenURLDidChangeSoundID() {
        
        let sound = try! SystemSoundID(url: frog)
        
        defer {
            try! sound.dispose()
        }
        
        XCTAssertTrue(sound.soundID != UInt32.max, "Sound was not initialized.")
    }
    
    func testOpenURLThrowsErrorWithNonSoundFile() {
        
        var didThrowError = false
        
        do {
            let sound = try SystemSoundID(url: URL(fileURLWithPath: "/Users/doofnugget/Desktop/Sachi.png"))
            
            defer {
                try! sound.dispose()
            }
            
        } catch {
            didThrowError = true
        }
        
        XCTAssertTrue(didThrowError, "Opening non-sound file failed to throw error.")
    }

    func testPropertyInfoSize() {
        do {
            
            let propInfo = try sound.propertyInfo(.isUISound)
            
            XCTAssertEqual(propInfo.size, UInt32(sizeof(UInt32)), "Did not obtain property size.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testPropertyInfoWritable() {
        do {
            
            let propInfo = try sound.propertyInfo(.isUISound)
            
            XCTAssertTrue(propInfo.writable, "Did not determine that property is writable.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testPropertySize() {
        do {
            
            let size = try sound.propertySize(.isUISound)
            
            XCTAssertEqual(size, UInt32(sizeof(UInt32)), "Did not determine that property is writable.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testPropertyIsWritable() {
        do {
            
            let writable = try sound.propertyIsWritable(.isUISound)
            
            XCTAssertTrue(writable, "Did not determine that property is writable.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testIsUISoundGetter() {
        
        do {
            
            let isUISound = try sound.isUISound()
            
            var size = UInt32(MemoryLayout<UInt32>.size)
            var _isUISound = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyIsUISound, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_isUISound)
            let uiSound = _isUISound == 1
            
            XCTAssertEqual(result, noErr, "testIsUISound internal error code \(result).")
            XCTAssertEqual(isUISound, uiSound, "isUISound property getter failed.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testIsUISoundSetsFalse() {
        
        do {
            
            try sound.isUISound(false)
            
            var size = UInt32(MemoryLayout<UInt32>.size)
            var _isUISound = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyIsUISound, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_isUISound)
            
            XCTAssertEqual(result, noErr, "testIsUISoundSetsFalse internal error code \(result).")
            XCTAssertEqual(_isUISound, 0, "isUISound(false) failed.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testIsUISoundSetsTrue() {
        
        do {
            
            try sound.isUISound(true)
            
            var size = UInt32(MemoryLayout<UInt32>.size)
            var _isUISound = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyIsUISound, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_isUISound)
            
            XCTAssertEqual(result, noErr, "testIsUISoundSetsTrue internal error code \(result).")
            XCTAssertEqual(_isUISound, 1, "isUISound(true) failed.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testCompletePlaybackIfAppDies() {
        
        do {
            
            let completes = try sound.completePlaybackIfAppDies()
            
            var size = UInt32(MemoryLayout<UInt32>.size)
            var _completes = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_completes)
            let willComplete = _completes == 1
            
            XCTAssertEqual(result, noErr, "testCompletePlaybackIfAppDies internal error code \(result).")
            XCTAssertEqual(completes, willComplete, "completePlaybackIfAppDies property failed.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testCompletePlaybackIfAppDiesSetsFalse() {
        
        do {
            
            try sound.completePlaybackIfAppDies(false)
            
            var size = UInt32(MemoryLayout<UInt32>.size)
            var _completes = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_completes)
            
            XCTAssertEqual(result, noErr, "testCompletePlaybackIfAddDiesSetsFalse internal error code \(result).")
            XCTAssertEqual(_completes, 0, "completePlaybackIfAppDies(false) failed.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testCompletePlaybackIfAppDiesSetsTrue() {
        
        do {
            
            try sound.completePlaybackIfAppDies(true)
            
            var size = UInt32(MemoryLayout<UInt32>.size)
            var _completes = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_completes)
            
            XCTAssertEqual(result, noErr, "testCompletePlaybackIfAppDiesSetsTrue internal error code \(result).")
            XCTAssertEqual(_completes, 1, "completePlaybackIfAppDies(true) failed.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testDispose() {
        
        do {
            let sound = try SystemSoundID(url: frog)
            try sound.dispose()
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testCompletionHandlerIsCalled() {
        
        var data = ClientData(expectation(description: "CallbackWasCalled"))
        
        do {
            
            try sound.addCompletion(inClientData: &data, inCompletionRoutine: callback)
            sound.play()
            
            waitForExpectations(timeout: 30) {
                error in
                if let error = error {
                    print("\(error)")
                }
            }
            
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    // TODO: Figure out how to test alert playback methods
    // TODO: Figure out how to test remove completion
}
