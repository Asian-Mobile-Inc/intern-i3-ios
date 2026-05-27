//
//  Observable.swift
//  MVVM
//
//  Created by Văn Tiến on 25/05/2026.
//

import Foundation

final class Observable<Value> {
    private var listener: ((Value) -> Void)?

    var value: Value {
        didSet {
            listener?(value)
        }
    }

    init(_ value: Value) {
        self.value = value
    }

    func bind(_ listener: @escaping (Value) -> Void) {
        self.listener = listener
        listener(value)
    }
}
