//
//  ViewController.swift
//  Mac_Project9_GCD
//
//  Created by Glenn Cole on 10/28/18.
//  Copyright © 2018 Glenn Cole. All rights reserved.
//
//  Worked-through tutorial from Paul Hudson's "Hacking With macOS"
//  https://www.hackingwithswift.com/store/hacking-with-macos
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        runBackgroundCode1()
//        runBackgroundCode2()
//        runBackgroundCode3()  //be sure to enable outgoing connections in Target > Capabilities > App Sandbox
//        runMultiprocessing()
        runNaiveFibonacci()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @objc func log( _ message: String ) {
        
        print( "Printing message: \(message)" )
    }
    
    func runBackgroundCode1() {
        
        performSelector(inBackground: #selector(log), with: "Hello world 1" )
        
        performSelector(onMainThread: #selector(log), with: "Hello world 2", waitUntilDone: false )
        
        log( "Hello world 3" )
    }
    
    func runBackgroundCode2() {
        
        DispatchQueue.global().async { [unowned self] in
            self.log( "On background thread" )
            
            DispatchQueue.main.async {
                self.log( "On main thread" )
            }
        }
    }
    
    func runBackgroundCode3() {
        
        DispatchQueue.global().async {
            
            guard let url = URL( string: "https://www.apple.com" ) else { return }
            guard let str = try? String( contentsOf: url )         else { return }
            
            print( str )
        }
    }
    
    func runMultiprocessing() {
        
        DispatchQueue.concurrentPerform( iterations: 10 ) {
            print( "concurrent iteration# \($0)" )
        }
    }
    
    func runNaiveFibonacci() {
        
        func fibonacci( of num: Int ) -> Int {
            return num < 2 ? num : fibonacci(of: num - 1) + fibonacci(of: num - 2)
        }
        
        var array = Array( 0 ..< 42 )
        let numNumbers = array.count
        let startTime = CFAbsoluteTimeGetCurrent()
        
        DispatchQueue.concurrentPerform(iterations: numNumbers ) {
            
            array[ $0 ] = fibonacci( of: $0 )
        }
        
        let totalTime = CFAbsoluteTimeGetCurrent() - startTime
        print( "Took \(totalTime) seconds to calculate the first \(numNumbers) Fibonacci numbers" )
    }
}

