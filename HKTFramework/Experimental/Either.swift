//
//  Either.swift
//  FunctorProject
//
//  Created by @strictlyswift on 7/15/18.
//

import Foundation

public enum Either<L,R> : DualConstructible {
    public typealias FixedType = L
    public typealias TypeParameter = R
    
    case left(L)
    case right(R)
}

/*
 instance Monad (Either e) where
 return = Right
 Right m >>= k = k m
 Left e  >>= _ = Left e
 
 instance Applicative (Either e) where
 pure = Right
 a <*> b = do x <- a; y <- b; return (x y)
*/

extension Either: Monad {
    public static func pure<V>(_ value: V) -> Either<L,V> {
        return Either<L,V>.right(value)
    }
    
    public func bind<V>(_ m: (R) -> Either<L,V>) -> Either<L,V> {
        switch self {
            case .right(let r): return m(r)
            case .left(let l): return Either<L,V>.left(l)
        }
    }
}

extension Either: Applicative {
    public func ap<V>(_ fab: Either<L,(R) -> V>) -> Either<L,V> {
        switch (self, fab) {
        case let (.left(_), .left(l2) ): return Either<L,V>.left(l2) // ??
        case let (.left(l1), .right(_) ): return Either<L,V>.left(l1)
        case let (.right(_), .left(l2) ): return Either<L,V>.left(l2)
        case let (.right(r1), .right(r2) ): return Either<L,V>.pure( r2(r1) )
        }
    }
}

extension Either : Functor {
    public func fmap<V>(_ transform: @escaping (R) -> V) -> Either<L,V> {
        switch self {
            case .left(let l): return Either<L,V>.left(l)
            case .right(let r): return Either<L,V>.right(transform(r))
        }
    }
}
