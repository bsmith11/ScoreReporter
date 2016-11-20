//
//  AsyncOperation.swift
//  ScoreReporterCore
//
//  Created by Bradley Smith on 11/19/16.
//  Copyright © 2016 Brad Smith. All rights reserved.
//

import Foundation

typealias AsyncOperationCompletionHandler = () -> Void
typealias AsyncOperationBlock = (_ completionHandler: @escaping AsyncOperationCompletionHandler) -> Void

class AsyncOperation: Operation {
    fileprivate let block: AsyncOperationBlock
    
    init(block: @escaping AsyncOperationBlock) {
        self.block = block
        
        super.init()
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    override func start() {
        _executing = true
        execute()
    }
    
    func execute() {
        block { [weak self] in
            self?.finish()
        }
    }
    
    func finish() {
        _executing = false
        _finished = true
    }
}
