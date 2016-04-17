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
    
    var sound: MySystemSound!
    
    let frog = NSURL(fileURLWithPath: "/System/Library/Sounds/Frog.aiff")

    override func setUp() {
        super.setUp()
        do {
            sound = MySystemSound(soundID: try MySystemSound.open(frog))
        } catch {
            print("\(error)")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        do {
            try sound.dispose()
        } catch {
            print("\(error)")
        }
    }

    func testOpenURLDidChangeSoundID() {
        XCTAssertTrue(sound.soundID != UInt32.max, "Sound was not initialized.")
    }
    
    func testOpenURLThrowsErrorWithNonSoundFile() {
    
        var didThrowError = false
        
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(NSURL(fileURLWithPath: "/Users/doofnugget/Desktop/Sachi.png")))
            XCTAssertTrue(sound.soundID != UInt32.max, "Sound was not initialized.")
        } catch {
            didThrowError = true
            print("\(error)")
        }
        
        XCTAssertTrue(didThrowError, "Opening non-sound file failed to throw error.")
    }
    
    func testPropertyInfoSize() {
        do {
            let propInfo = try sound.propertyInfo(.IsUISound)
            
            XCTAssertTrue(propInfo.size != UInt32.max, "Did not obtain property size.")
        } catch {
            print("\(error)")
            XCTFail("Error thrown.")
        }
    }
    
    func testPropertyInfoWritable() {
        do {
            let propInfo = try sound.propertyInfo(.IsUISound)
            
            XCTAssertTrue(propInfo.writable, "Did not determine that property is writable.")
        } catch {
            print("\(error)")
            XCTFail("Error thrown.")
        }
    }
    
    func testPropertySize() {
        do {
            let size = try sound.propertySize(.IsUISound)
            
            XCTAssertTrue(size != UInt32.max, "Did not determine that property is writable.")
        } catch {
            print("\(error)")
            XCTFail("Error thrown.")
        }
    }
    
    func testPropertyIsWritable() {
        do {
            let writable = try sound.propertyIsWritable(.IsUISound)
            
            XCTAssertTrue(writable, "Did not determine that property is writable.")
        } catch {
            print("\(error)")
            XCTFail("Error thrown.")
        }
    }
    
    func testIsUISoundGetter() {
        
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            let isUISound = try sound.isUISound()
            
            var size = UInt32(sizeof(UInt32.self))
            var _isUISound = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyIsUISound, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_isUISound)
            
            XCTAssertTrue(result == 0 && isUISound == (_isUISound == 1), "isUISound property failed.")
        } catch {
            print("\(error)")
            XCTFail("Error thrown.")
        }
    }
    
    func testIsUISoundSetsFalse() {
        
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            try sound.isUISound(false)
            
            var size = UInt32(sizeof(UInt32.self))
            var _isUISound = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyIsUISound, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_isUISound)
            
            XCTAssertTrue(result == 0 && _isUISound == 0, "isUISound(false) failed.")
        } catch {
            print("\(error)")
            XCTFail("Error thrown.")
        }
    }
    
    func testIsUISoundSetsTrue() {
        
        do {
            try sound.isUISound(true)
            
            var size = UInt32(sizeof(UInt32.self))
            var _isUISound = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyIsUISound, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_isUISound)
            
            XCTAssertTrue(result == 0 && _isUISound == 1, "isUISound(true) failed.")
        } catch {
            print("\(error)")
            XCTFail("Error thrown.")
        }
    }
    
    func testCompletePlaybackIfAppDies() {
        
        do {
            let completes = try sound.completePlaybackIfAppDies()
            
            var size = UInt32(sizeof(UInt32.self))
            var _completes = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_completes)
            
            XCTAssertTrue(result == 0 && completes == (_completes == 1), "completePlaybackIfAppDies property failed.")
        } catch {
            print("\(error)")
            XCTFail("Error thrown.")
        }
    }
    
    func testCompletePlaybackIfAppDiesSetsFalse() {
        
        do {
            try sound.completePlaybackIfAppDies(false)
            
            var size = UInt32(sizeof(UInt32.self))
            var _completes = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_completes)
            
            XCTAssertTrue(result == 0 && _completes == 0, "completePlaybackIfAppDies(false) failed.")
        } catch {
            print("\(error)")
            XCTFail("Error thrown.")
        }
    }
    
    func testCompletePlaybackIfAppDiesSetsTrue() {
        
        do {
            try sound.completePlaybackIfAppDies(true)
            
            var size = UInt32(sizeof(UInt32.self))
            var _completes = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_completes)
            
            XCTAssertTrue(result == 0 && _completes == 1, "completePlaybackIfAppDies(true) failed.")
        } catch {
            print("\(error)")
            XCTFail("Error thrown.")
        }
    }
    
    func testDispose() {
        
        do {
            try sound.dispose()
        } catch {
            XCTFail("Error thrown.")
        }
    }
}