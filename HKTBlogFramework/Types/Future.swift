//
//  Future.swift
//  HKT
//
//  Created by @strictlyswift on 5/9/18.
//

import Foundation
import HKTFramework

// https://www.swiftbysundell.com/posts/under-the-hood-of-futures-and-promises-in-swift

public enum Result<Value> {
    case value(Value)
    case error(Error)
}

public class Future<Value> : Constructible {
    public typealias TypeParameter = Value
    
    fileprivate var result: Result<Value>? {
        // Observe whenever a result is assigned, and report it
        didSet { result.map(report) }
    }
    private lazy var callbacks = [(Result<Value>) -> Void]()
    
    public func observe(with callback: @escaping (Result<Value>) -> Void) {
        callbacks.append(callback)
        
        // If a result has already been set, call the callback directly
        result.map(callback)
    }
    
    private func report(result: Result<Value>) {
        for callback in callbacks {
            callback(result)
        }
    }
}

public class Promise<Value>: Future<Value> {
    public init(value: Value? = nil) {
        super.init()
        
        // If the value was already known at the time the promise
        // was constructed, we can report the value directly
        result = value.map(Result.value)
    }
    
    public func resolve(with value: Value) {
        result = .value(value)
    }
    
    public func reject(with error: Error) {
        result = .error(error)
    }
}

extension URLSession {
    public func requestData(url: URL) -> Future<Data> {
        // Start by constructing a Promise, that will later be
        // returned as a Future
        let promise = Promise<Data>()
        
        // Perform a data task, just like normal
        dataTask(with: url) { data, _, error in
            // Reject or resolve the promise, depending on the result
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: data ?? Data())
            }
        }.resume()
        
        return promise
    }
}

extension Future : Monad {
    public static func pure<A>(_ a: A) -> Future<A> {
        return Promise<A>(value: a)   // you get a promise, not a future
    }
    
    public func bind<B>(_ m: @escaping (Value) throws -> Future<B>) -> Future<B> {
        let promise = Promise<B>()
        
        // Observe the current future
        observe { result in
            switch result {
            case .value(let value):
                do {
                    // Attempt to construct a new future given
                    // the value from the first one
                    let future = try m(value)
                    
                    // Observe the "nested" future, and once it
                    // completes, resolve/reject the "wrapper" future
                    future.observe { result in
                        switch result {
                        case .value(let value):
                            promise.resolve(with: value)
                        case .error(let error):
                            promise.reject(with: error)
                        }
                    }
                } catch {
                    promise.reject(with: error)
                }
            case .error(let error):
                promise.reject(with: error)
            }
        }
        
        return promise
    }
}


extension Future : Functor {
    public func fmap<B>(_ transform: @escaping (Value) throws -> B) -> Future<B> {
        return bind { value in
            return try Promise(value: transform(value))
        }
    }
}



