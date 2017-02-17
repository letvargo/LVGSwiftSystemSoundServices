//
//  SystemSoundTests.swift
//  Tests
//
//  Created by doof nugget on 4/30/16.
//
//

import XCTest
import LVGSwiftSystemSoundServices

class SystemSoundTests: XCTestCase {
    
    class SSDelegate: SystemSoundDelegate {
        
        let expectation: XCTestExpectation
        var wasCalled = false
        
        init(expectation: XCTestExpectation) {
            self.expectation = expectation
        }
        
        func didFinishPlaying(_ sound: SystemSound) {
            self.wasCalled = true
            expectation.fulfill()
        }
    }
    
    let frog = URL(fileURLWithPath: "/System/Library/Sounds/Frog.aiff")
    
    var sound: SystemSound!
    
    override func setUp() {
        self.sound = try! SystemSound(url: frog)
    }
    
    override func tearDown() {
        self.sound = nil
    }
    
    func testOpenURLThrowsErrorWithNonSoundFile() {
        
        var didThrowError = false
        
        do {
            let _ = try SystemSound(url: URL(fileURLWithPath: "/Users/doofnugget/Desktop/Sachi.png"))
            
        } catch {
            didThrowError = true
        }
        
        XCTAssertTrue(didThrowError, "Opening non-sound file failed to throw error.")
    }
    
    func testIsUISoundGetter() {
        
        do {
            
            let isUISound = try sound.isUISound()
            
            XCTAssertTrue(isUISound, "isUISound property getter failed.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testIsUISoundSetsFalse() {
        
        do {
            
            try sound.isUISound(false)
            XCTAssertFalse(try sound.isUISound(), "isUISound(false) failed.")
            
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testIsUISoundSetsTrue() {
        
        do {
            
            try sound.isUISound(true)
            XCTAssertTrue(try sound.isUISound(), "isUISound(true) failed.")
            
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testCompletePlaybackIfAppDies() {
        
        do {
            
            let completes = try sound.completePlaybackIfAppDies()
            XCTAssertFalse(completes, "completePlaybackIfAppDies property failed.")
            
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testCompletePlaybackIfAppDiesSetsFalse() {
        
        do {
            
            try sound.completePlaybackIfAppDies(false)
            XCTAssertFalse(try sound.completePlaybackIfAppDies(), "completePlaybackIfAppDies(false) failed.")
            
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testCompletePlaybackIfAppDiesSetsTrue() {
        
        do {
            
            try sound.completePlaybackIfAppDies(true)
            
            XCTAssertTrue(try sound.completePlaybackIfAppDies(), "completePlaybackIfAppDies(true) failed.")
        } catch {
            XCTFail("Error thrown:\n\(error)")
        }
    }
    
    func testDelegateIsCalled() {
        
        let expectation = self.expectation(description: "CallbackWasCalled")
        let delegate = SSDelegate(expectation: expectation)
        sound.delegate = delegate
        
        sound.play()
        
        waitForExpectations(timeout: 10) {
            error in
            if let error = error {
                print("\(error)")
                XCTFail("Error while waiting for delegate to fulfill expectation.")
            }
        }
        
        XCTAssertTrue(delegate.wasCalled, "Delegate method was not called.")
    }
}
