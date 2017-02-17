//
//  SystemSoundDelegate.swift
//  Pods
//
//  Created by doof nugget on 4/24/16.
//
//


/// A protocol for adding a completion handler to a `SystemSound`.
public protocol SystemSoundDelegate: class {

    /// This method is called when the `SystemSound` has completed playing.
    func didFinishPlaying(_ sound: SystemSound)
}
