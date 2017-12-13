//
//  ClosureTimer.swift
//  Scenes
//
//  Created by Perry on 30/08/2016.
//  Copyright © 2017 perrchick. All rights reserved.
//

import Foundation

class ClosureTimer {
    var timer: Timer?
    let block: CompletionClosure<Any?>
    /// Inspired from: http://blog.hourglasslab.com/2017/04/19/timer%20on%20background%20thread/
    let queue: DispatchQueue

    init(afterDelay seconds: TimeInterval = 0.0, userInfo: Any?, queue :DispatchQueue = DispatchQueue.main, repeats: Bool, block: @escaping CompletionClosure<Any>) {
        
        self.queue = queue
        self.block = block

        queue.async { [unowned self] in
            let currentRunLoop = RunLoop.current
            let timer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(ClosureTimer.timerFired(_:)), userInfo: userInfo, repeats: repeats)
            currentRunLoop.add(timer, forMode: .commonModes)
            currentRunLoop.run()
            self.timer = timer
        }
    }

    @objc func timerFired(_ timer: Timer) {
        self.block(timer.userInfo as AnyObject?)
    }

    func invalidate() {
        timer?.invalidate()
    }
    
    @discardableResult
    static func runBlockAfterDelay(afterDelay seconds: Double, repeats: Bool = false, userInfo: Any? = nil, onQueue: DispatchQueue = DispatchQueue.main, block: @escaping CompletionClosure<Any>) -> ClosureTimer {
        let timer = ClosureTimer(afterDelay: seconds, userInfo: userInfo, queue: onQueue, repeats: repeats, block: block)
        return timer
    }
}
