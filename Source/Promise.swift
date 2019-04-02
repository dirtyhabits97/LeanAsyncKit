//
//  Promise.swift
//  LeanAsyncKit
//
//  Created by Gonzalo Reyes Huertas on 4/1/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

public struct Promise<Value, Error: Swift.Error> {
    
    private var onHold: Result<Value, Error>?
    private var onFullfilled: ((Value) -> Void)?
    private var onRejected: ((Error) -> Void)?
    
    public init() { }
    
    public mutating func onFullfilled<Observer: AnyObject>(observer: Observer,
                                                           _ completion: @escaping (Observer, Value) -> Void) {
        // trigger if value exists
        onHold?.value.map { completion(observer, $0) }
        // set fullfilled closure
        onFullfilled = { [weak observer] value in
            guard let observer = observer else { return }
            completion(observer, value)
        }
    }
    
    public mutating func onRejected<Observer: AnyObject>(observer: Observer,
                                                         _ completion: @escaping (Observer, Error) -> Void) {
        // trigger if value exists
        onHold?.error.map { completion(observer, $0) }
        // set rejected closure
        onRejected = { [weak observer] value in
            guard let observer = observer else { return }
            completion(observer, value)
        }
    }
    
    public mutating func resolve(with result: Result<Value, Error>) {
        onHold = result
        result.value.map { onFullfilled?($0) }
        result.error.map { onRejected?($0) }
    }
    
    public mutating func resolve(with value: Value) {
        onHold = .success(value)
        onFullfilled?(value)
    }
    
    public mutating func resolve(with error: Error) {
        onHold = .failure(error)
        onRejected?(error)
    }
    
}
