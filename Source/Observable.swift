//
//  Observable.swift
//  LeanAsyncKit
//
//  Created by Gonzalo Reyes Huertas on 4/1/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

public struct Observable<Value> {
    
    private var onHold: Value?
    private var closures: [(Value) -> Void] = []
    
    public init() { }
    
    public mutating func bind<Observer: AnyObject>(to observer: Observer,
                                                   _ completion: @escaping (Observer, Value) -> Void) {
        // trigger if value exists
        onHold.map { completion(observer, $0) }
        // add observer
        closures.append { [weak observer] (value) in
            guard let observer = observer else { return }
            completion(observer, value)
        }
    }
    
    public mutating func notify(with value: Value) {
        onHold = value
        for closure in closures { closure(value) }
    }
    
}
