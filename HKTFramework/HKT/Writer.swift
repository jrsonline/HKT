//
//  Writer.swift
//  HKT
//
//  Created by @strictlyswift on 2/2/18.
//

import Foundation

// The 'sourcery' line is necessary for Sourcery to be able to create the WriterTag with the Monoid constraint!
// sourcery: FixedTypeConstraint = Monoid
/// Writer<W,V> represents an accumulation (eg a log, or a sum) together with a value.
///
/// Repeated assignments to the Writer, eg via a Monad bind `>>>=`, update both the value V as well
/// as the accumulator W. W must therefore be a Monoid with an `id` and an accumulate `<>` operator.
struct Writer<W : Monoid, V>  : DualConstructible {
    typealias TypeParameter = V
    typealias FixedType = W
    let writing: W
    let value: V
}

extension Writer : Functor {
    func fmap<B>(_ transform: @escaping (TypeParameter) -> B) -> Writer<FixedType,B> {
        return Writer<FixedType,B>(writing: writing, value: transform(value))
    }
}

extension Writer: Monad {
    static func pure<V>(_ value: V) -> Writer<FixedType,V> {
        return Writer<W,V>(writing: W.id, value: value)
    }
    
    func bind<B>(_ m: (TypeParameter) -> Writer<FixedType,B>) -> Writer<FixedType,B> {
        let originalWriter = self
        let updatedWriter = m(originalWriter.value)
        return Writer<W,B>( writing: originalWriter.writing <> updatedWriter.writing, value: updatedWriter.value )
    }
}
