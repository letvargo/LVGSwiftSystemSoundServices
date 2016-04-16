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
    
    let frog = NSURL(fileURLWithPath: "/System/Library/Sounds/Frog.aiff")

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testOpenURLDidChangeSoundID() {
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            XCTAssertTrue(sound.soundID != UInt32.max, "Sound was not initialized.")
        } catch {
            print("\(error)")
        }
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
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            let propInfo = try sound.propertyInfo(.IsUISound)
            
            XCTAssertTrue(propInfo.size != UInt32.max, "Did not obtain property size.")
        } catch {
            print("\(error)")
        }
    }
    
    func testPropertyInfoWritable() {
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            let propInfo = try sound.propertyInfo(.IsUISound)
            
            XCTAssertTrue(propInfo.writable, "Did not determine that property is writable.")
        } catch {
            print("\(error)")
        }
    }
    
    func testPropertySize() {
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            let size = try sound.propertySize(.IsUISound)
            
            XCTAssertTrue(size != UInt32.max, "Did not determine that property is writable.")
        } catch {
            print("\(error)")
        }
    }
    
    func testPropertyIsWritable() {
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            let writable = try sound.propertyIsWritable(.IsUISound)
            
            XCTAssertTrue(writable, "Did not determine that property is writable.")
        } catch {
            print("\(error)")
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
            XCTFail()
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
            XCTFail()
        }
    }
    
    func testIsUISoundSetsTrue() {
        
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            try sound.isUISound(true)
            
            var size = UInt32(sizeof(UInt32.self))
            var _isUISound = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyIsUISound, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_isUISound)
            
            XCTAssertTrue(result == 0 && _isUISound == 1, "isUISound(true) failed.")
        } catch {
            print("\(error)")
            XCTFail()
        }
    }
    
    func testCompletePlaybackIfAppDies() {
        
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            let completes = try sound.completePlaybackIfAppDies()
            
            var size = UInt32(sizeof(UInt32.self))
            var _completes = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_completes)
            
            XCTAssertTrue(result == 0 && completes == (_completes == 1), "completePlaybackIfAppDies property failed.")
        } catch {
            print("\(error)")
            XCTFail()
        }
    }
    
    func testCompletePlaybackIfAppDiesSetsFalse() {
        
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            try sound.completePlaybackIfAppDies(false)
            
            var size = UInt32(sizeof(UInt32.self))
            var _completes = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_completes)
            
            print(_completes)
            
            XCTAssertTrue(result == 0 && _completes == 0, "completePlaybackIfAppDies(false) failed.")
        } catch {
            print("\(error)")
            XCTFail()
        }
    }
    
    func testCompletePlaybackIfAppDiesSetsTrue() {
        
        do {
            let sound = MySystemSound(soundID: try MySystemSound.open(frog))
            try sound.completePlaybackIfAppDies(true)
            
            var size = UInt32(sizeof(UInt32.self))
            var _completes = UInt32.max
            
            let result = AudioServicesGetProperty(kAudioServicesPropertyCompletePlaybackIfAppDies, UInt32(sizeofValue(sound.soundID)), [sound.soundID], &size, &_completes)
            
            XCTAssertTrue(result == 0 && _completes == 1, "completePlaybackIfAppDies(true) failed.")
        } catch {
            print("\(error)")
            XCTFail()
        }
    }
}