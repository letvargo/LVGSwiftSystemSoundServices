# LVGSwiftSystemSoundServices

[![CI Status](http://img.shields.io/travis/letvargo/LVGSwiftSystemSoundServices.svg?style=flat)](https://travis-ci.org/letvargo/LVGSwiftSystemSoundServices)
[![Version](https://img.shields.io/cocoapods/v/LVGSwiftSystemSoundServices.svg?style=flat)](http://cocoapods.org/pods/LVGSwiftSystemSoundServices)
[![License](https://img.shields.io/cocoapods/l/LVGSwiftSystemSoundServices.svg?style=flat)](http://cocoapods.org/pods/LVGSwiftSystemSoundServices)
[![Platform](https://img.shields.io/cocoapods/p/LVGSwiftSystemSoundServices.svg?style=flat)](http://cocoapods.org/pods/LVGSwiftSystemSoundServices)

A wrapper around Audio Toolbox's [System Sound Services API](https://developer.apple.com/library/mac/documentation/AudioToolbox/Reference/SystemSoundServicesReference/).

`LVGSwiftSystemSoundServices` makes creating and playing system sounds easy. System sounds can be created in a single line of code using the provided `SystemSound` class:

    let sound = try SystemSound(url: mySoundURL)
    
Sounds can then be played with the `play()` method:

    sound.play()
    
`LVGSwiftSystemSoundServices` also defines a protocol, `SystemSoundType`, with default implementations for all of the System Sound Services functions. If you want all of the tools available through the System Sound Services API, you can conform your custom type to `SystemSoundType` by giving it a `soundID` property:

    struct MySystemSound: SystemSoundType {
        var soundID: SystemSoundID
    }
    
A variety of tools for creating and playing the sound are available, as discussed in detail below.
    
## About System Sound Services:

Apple describes the System Sound Services this way:

> You can use System Sound Services to play short (30 seconds or shorter) sounds. The interface does not provide level, positioning, looping, or timing control, and does not support simultaneous playback: You can play only one sound at a time. You can use System Sound Services to provide audible alerts. On some iOS devices, alerts can include vibration.

System sounds are useful mainly when you have a short sound, such as an alert sound, that you need to play in response to a user interaction. They can also be used to make an iOS device vibrate, or flash the screen on OS X.

## Overview

`LVGSwiftSystemSoundServices` is made up of the following components:
 - `SystemSoundType`: A protocol with default extension methods for all of the functions defined in the System Sound Services API.
 - `SystemSound`: A class that makes it easy to create and play system sounds, and that includes a `delegate` protocol that can be used to perform actions after a sound has completed playing.
 - `SystemSoundID`: An extension to `SystemSoundID` that conforms it to the `SystemSoundType` protocol.
 - `SystemSoundDelegate`: A protocol with a single function requirement, `didFinishPlaying(_:)`. This protocol is used to implement completion handling for the `SystemSound` class.
 - `SystemSoundProperty`: An enum that represents the system sound properties defined by System Sound Services. This enum is used in place of the property constants defined by the System Sound Services API.
 - `SystemSoundError`: An `ErrorType` enum that represents the various `OSStatus` error codes defined by System Sound Services. Traditional Swift error handling replaces the awkward `OSStatus` codes that are returned by System Sound Services functions.

### Using `SystemSound`

The `SystemSound` class makes it easy to create and play system sounds. You initialize a `SystemSound` with the URL to the sound file that you want to play.

The `SystemSound` class has a `delegate` property that can be set to any object that conforms to the `SystemSoundDelegate` protocol. The `SystemSoundDelegate` protocol has only one required method, `didFinishPlaying(_:)`, which is called when the sound is done playing.

The following short example shows how to configure a basic `SystemSound` as a view controller property:

    class ViewController: UIViewController, SystemSoundDelegate {
      var mySound: SystemSound?
        
      override func viewDidLoad() {
        // soundURL is a valid NSURL to a sound file
        mySound = try? SystemSound(url: soundURL)            
        mySound?.delegate = self
      }
        
      func didFinishPlaying(sound: SystemSound) {
        print("The sound has finished playing.")
      }
    }

Once the `SystemSound` has been associated with an URL, it can be played using `mySound?.play()`, or played as an alert using `mySound?.playAsAlert()`. The `delegate`'s `didFinishPlaying(_:)` method will be called when the sound has finished playing. It is not necessary to set the `delegate` property if you don't need this functionality.

When using the `SystemSound` class you do not need to worry about disposing of the system sound when you are done with it. The system sound will be automatically disposed of when the `SystemSound` object is de-initialized.

### Using `SystemSoundID`

`SystemSoundID` (which is just a `typealias` for `UInt32`) has been conformed to `SystemSoundType`. That means that any `UInt32` value can be used as a system sound. All you have to do is initialize it with the URL of the sound file that you want to associate it with:

    var mySound = try! SystemSoundID(url: soundURL)

Once initialized you can call any of the available `SystemSoundType` methods on it:

    // Play the sound
    mySound.play()

    // Play the sound as an alert
    mySound.playAsAlert()
    
System sounds should be disposed of when you are through using them. The following code is an example of a view controller declaring a `soundID` property, initializing it in `viewDidLoad()` and disposing of it in it's `deinit` method:

    class ViewController: UIViewController {
      var soundID: SystemSoundID?
        
      override func viewDidLoad() {
          // soundURL is a valid NSURL to a sound file
          soundID = try? SystemSoundID(url: soundURL)
      }
        
      deinit {
        do {
          try soundID.dispose()
        } catch {
          print("\(error)")
        }
      }
    }

Note that if you use the `SystemSound` class instead of `SystemSoundID`, you do not need to dispose of the sound. It is automatically disposed of in `SystemSound`'s `deinit` method.

### Adding Completion Handlers

System sounds allow you to add a completion handler that will be called when the sound is finished playing. `SystemSoundType` has two methods for adding and removing completion handlers:

    // Add a completion handler
    public func addCompletion(
      inRunLoop: NSRunLoop? = nil,
      inRunLoopMode: String? = nil,
      inClientData: UnsafeMutablePointer<Void> = nil,
      inCompletionRoutine: AudioServicesSystemSoundCompletionProc) throws
      
    // Remove a completion handler
    public func removeCompletion()
    
If you use the built-in `SystemSound` class, there are no completion handlers. Instead, use the `SystemSound`'s `delegate` property to assign a delegate to the system sound. The delegate's `didFinishPlaying(_:)` method will be called when the sound is finished playing.

### Accessing the System Sound's Properties

Both the `SystemSoundType` protocol and the `SystemSound` class provide methods for getting and setting a system sound's properties:

    // Get and set the kAudioServicesPropertyIsUISound property
    public func isUISound() throws -> Bool
    public func isUISound(value: Bool) throws

    // Get and set the kAudioServicesPropertyCompletePlaybackIfAppDies property
    public func completePlaybackIfAppDies() throws -> Bool
    public func completePlaybackIfAppDies(value: Bool) throws

`SystemSoundType` has additional methods for getting the property size and determining whether the property is writable. See the documentation on the [CocoaPods](http://cocoapods.org) website for further information.

## Requirements

 - OS X 10.10 or later
 - iOS 8.0 or later

## Installation

LVGSwiftSystemSoundServices is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LVGSwiftSystemSoundServices"
```

## Author

letvargo, letvargo@gmail.com

## License

LVGSwiftSystemSoundServices is available under the MIT license. See the LICENSE file for more info.
