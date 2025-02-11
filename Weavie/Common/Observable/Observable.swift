//
//  Observable.swift
//  Weavie
//
//  Created by 정인선 on 2/7/25.
//

import Foundation

final class Observable<T> {
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    var closure: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> Void) {
        closure(value)
        self.closure = closure
    }
    
    func lazyBind(closure: @escaping (T) -> Void) {
        self.closure = closure
    }
}
