//
//  Stopwatch.swift
//  Stopwatch
//
//  Created by Pedro Fernandez on 12/13/21.
//

import Foundation

enum StopwatchMode {
    case paused
    case running
    case stopped
}

protocol StopwatchDelegate: AnyObject {
    func stopwatchFired(_ stopwatch: Stopwatch, elapsedTime: String)
}

class Stopwatch {
    // MARK: Variables
    static let defaultTime = "00:00.00"
    weak var delegate: StopwatchDelegate?
    var mode: StopwatchMode = .stopped
    var elapsedTime: Double = 0.0
    var timer = Timer()
    
    init() {
    }
    
    func getElapsedTime() -> String {
        return elapsedTimeToString(time: elapsedTime)
    }
    
    func start() {
        mode = .running
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [self] _ in
            elapsedTime += 0.01
            delegate?.stopwatchFired(self, elapsedTime: elapsedTimeToString(time: elapsedTime))
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func stop() {
        mode = .stopped
        timer.invalidate()
        elapsedTime = 0.0
    }
    
    func pause() {
        mode = .paused
        timer.invalidate()
    }
    
    func reset() {
        mode = .stopped
        elapsedTime = 0.0
    }
    
    func restart() {
        elapsedTime = 0.0
    }
    
    private func elapsedTimeToString(time: Double) -> String {
        // Format minutes
        let minutes = Int(time/60)
        var minutesString = String(minutes)
        if minutes < 10 {
            minutesString = "0\(minutes)"
        }
        
        // Format milliseconds
        var seconds: String = String(format: "%.2f", (time.truncatingRemainder(dividingBy: 60)))
        if time.truncatingRemainder(dividingBy: 60) < 10 {
          seconds = "0" + seconds
        }
        
        return minutesString + ":" + seconds
    }
}
