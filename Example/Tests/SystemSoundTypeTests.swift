//
//  SystemSoundTypeTests.swift
//  LVGSwiftSystemSoundServices
//
//  Created by doof nugget on 4/15/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import XCTest
import LVGSwiftSystemSoundServices

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
}
