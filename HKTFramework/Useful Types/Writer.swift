//
//  Writer.swift
//  HKT
//
//  Created by JonLily on 2/2/18.
//  Copyright © 2018 jsoft-online. All rights reserved.
//

import Foundation

// The 'sourcery' line is necessary for Sourcery to be able to create the WriterTag with the Monoid constraint!
// sourcery: FixedTypeConstraint = Monoid
/// Writer<W,V> represents an accumulation (eg a log, or a sum) together with a value.
///
/// Repeated assignments to the Writer, eg via a Monad bind `>>>=`, update both the value V as well
/// as the accumulator W. W must therefore be a Monoid with an `id` and an accumulate `<>` operator.
public struct Writer<W : Monoid, V>  : DualConstructible {
    public typealias TypeParameter = V
    public typealias FixedType = W
    public let writing: W
    public let value: V
    
    public init(writing: W, value:V) {
        self.writing = writing
        self.value = value
    }
    
    public func write(_ add: W) -> Writer<W,V> {
        return Writer(writing: self.writing <> add, value: self.value)
    }
}

extension Writer : Functor {
    public func fmap<B>(_ transform: @escaping (TypeParameter) -> B) -> Writer<FixedType,B> {
        return Writer<FixedType,B>(writing: writing, value: transform(value))
    }
}

extension Writer: Monad {
    public static func pure<V>(_ value: V) -> Writer<FixedType,V> {
        return Writer<W,V>(writing: W.id, value: value)
    }
    
    public func bind<B>(_ m: (TypeParameter) -> Writer<FixedType,B>) -> Writer<FixedType,B> {
        let originalWriter = self
        let updatedWriter = m(originalWriter.value)
        return Writer<W,B>( writing: originalWriter.writing <> updatedWriter.writing, value: updatedWriter.value )
    }
}
