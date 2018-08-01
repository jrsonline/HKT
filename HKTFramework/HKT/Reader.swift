//
//  Reader.swift
//  HKT
//
//  Created by @strictlyswift on 5/3/18.
//

import Foundation

/// Reader<E,A> represents a single-valued function from `(E) -> A`.
///
/// Calling `apply` on a Reader applies the function with the passed-in argument. Readers allow for deferred exection of functions.
struct Reader<E, A> : DualConstructible {

    typealias TypeParameter = A
    typealias FixedType = E
    
    let g: (E) -> A
    
    init(g: @escaping (E) -> A) {
        self.g = g
    }
    
    func apply(e: E) -> A {
        return g(e)
    }
 
}

extension Reader : Functor {
    func fmap<B>(_ transform: @escaping (A) -> B) -> Reader<E,B> {
        return Reader<E,B>{ e in transform(self.g(e)) }
    }
}

extension Reader : Monad {
    static func pure<V>(_ v: V) -> Reader<FixedType,V> {
        return Reader<FixedType,V>{_ in v}
    }
    
    func bind<B>(_ m: @escaping (TypeParameter) -> Reader<FixedType,B>) -> Reader<FixedType,B> {
        return Reader<FixedType,B>{ e in m(self.g(e)).g(e) }
    }
}


