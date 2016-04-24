//
//  SystemSoundTypeTests.swift
//  LVGSwiftSystemSoundServices
//
//  Created by doof nugget on 4/15/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import LVGSwiftSystemSoundServices
import AudioToolbox

class SystemSoundTypeTests: XCTestCase {
    
    typealias SystemSoundID = UInt32
    
    struct MySystemSound: SystemSoundType {
        var soundID: SystemSoundID
    }
    
    struct ClientData {
        var expectation: XCTestExpectation
        var wasCalled = false
        
        init(_ expectation: XCTestExpectation) {
            self.expectation = expectation
        }
    }
    
    let callback: AudioServicesSystemSoundCompletionProc = { ssID, inClientData in
        var data = UnsafeMutablePointer<ClientData>(inClientData)
        data.memory.wasCalled = true
        data.memory.expectation.fulfill()
    }
    
    let frog = NSURL(fileURLWithPath: "/System/Library/Sounds/Frog.aiff")
    
    func testOpenURLDidChangeSoundID() {
        
        let sound = MySystemSound(soundID: try! MySystemSound.open(frog))
        
        defer {
            try! sound.dispose()
        }
        
        XCTAssertTrue(sound.soundID != UInt32.max, "Sound was not initialized.")
    }
    
    func testOpenURLThrowsErrorWithNonSoundFile() {
        
        var didThrowError = false
        
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(NSURL(fileURLWithPath: "/Users/doofnugget/Desktop/Sachi.png")))
            
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
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            
            defer {
                try! sound.dispose()
            }
            
            let propInfo = try sound.propertyInfo(.IsUISound)
            
            XCTAssertTrue(propInfo.size != UInt32.max, "Did not obtain property size.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testPropertyInfoWritable() {
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            
            defer {
                try! sound.dispose()
            }
            
            let propInfo = try sound.propertyInfo(.IsUISound)
            
            XCTAssertTrue(propInfo.writable, "Did not determine that property is writable.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testPropertySize() {
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            
            defer {
                try! sound.dispose()
            }
            
            let size = try sound.propertySize(.IsUISound)
            
            XCTAssertTrue(size != UInt32.max, "Did not determine that property is writable.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testPropertyIsWritable() {
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            
            defer {
                try! sound.dispose()
            }
            
            let writable = try sound.propertyIsWritable(.IsUISound)
            
            XCTAssertTrue(writable, "Did not determine that property is writable.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testIsUISoundGetter() {
        
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            
            defer {
                try! sound.dispose()
            }
            
            let isUISound = try sound.isUISound()
            
            var size = UInt32(sizeof(UInt32.self))
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
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            
            defer {
                try! sound.dispose()
            }
            
            try sound.isUISound(false)
            
            var size = UInt32(sizeof(UInt32.self))
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
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            
            defer {
                try! sound.dispose()
            }
            
            try sound.isUISound(true)
            
            var size = UInt32(sizeof(UInt32.self))
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
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            
            defer {
                try! sound.dispose()
            }
            
            let completes = try sound.completePlaybackIfAppDies()
            
            var size = UInt32(sizeof(UInt32.self))
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
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            
            defer {
                try! sound.dispose()
            }
            
            try sound.completePlaybackIfAppDies(false)
            
            var size = UInt32(sizeof(UInt32.self))
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
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            
            defer {
                try! sound.dispose()
            }
            
            try sound.completePlaybackIfAppDies(true)
            
            var size = UInt32(sizeof(UInt32.self))
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
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            try sound.dispose()
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testCompletionHandlerIsCalled() {
        
        var data = ClientData(expectationWithDescription("CallbackWasCalled"))
        
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            
            defer {
                try! sound.dispose()
            }
            
            try sound.addCompletion(inClientData: &data, inCompletionRoutine: callback)
            sound.play()
            
            waitForExpectationsWithTimeout(30) {
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