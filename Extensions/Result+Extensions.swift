//
//  Result+Extensions.swift
//  LeanAsyncKit
//
//  Created by Gonzalo Reyes Huertas on 4/1/19.
//  Copyright © 2019 Gonzalo Reyes Huertas. All rights reserved.
//

extension Result {
    
    var value: Success? {
        switch self {
        case .success(let v): return v
        case .failure: return nil
        }
    }
    
    var error: Failure? {
        switch self {
        case .success: return nil
        case .failure(let e): return e
        }
    }
    
}
