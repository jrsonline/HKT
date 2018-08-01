//
//  Reader.swift
//  HKT
//
//  Created by JonLily on 5/3/18.
//  Copyright © 2018 jsoft-online. All rights reserved.
//

import Foundation

/// Reader<E,A> represents a single-valued function from `(E) -> A`.
///
/// Calling `apply` on a Reader applies the function with the passed-in argument. Readers allow for deferred exection of functions.
public struct Reader<E, A> {

    let g: (E) -> A
    
    public init(g: @escaping (E) -> A) {
        self.g = g
    }
    
    public func apply(_ e: E) -> A {
        return g(e)
    }
 
}

extension Reader : DualConstructible {
    public typealias TypeParameter = A
    public typealias FixedType = E
    
}

extension Reader : Functor {
    public func fmap<B>(_ transform: @escaping (A) -> B) -> Reader<E,B> {
        return Reader<E,B>{ e in transform(self.g(e)) }
    }
}

extension Reader : Monad {
    public static func pure<V>(_ v: V) -> Reader<FixedType,V> {
        return Reader<FixedType,V>{_ in v}
    }
    
    public func bind<B>(_ m: @escaping (TypeParameter) -> Reader<FixedType,B>) -> Reader<FixedType,B> {
        return Reader<FixedType,B>{ e in m(self.g(e)).g(e) }
    }
}


