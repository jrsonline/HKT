//
//  ZipArray.swift
//  HKT
//
//  Created by @strictlyswift on 3/19/18.
//

import Foundation


public struct ZipArray<Element> : Constructible, CustomStringConvertible {
    public typealias TypeParameter = Element
    public let array : [Element]
    fileprivate let unsized : Bool
    
    public var count : Int { get { return array.count }}
    public var description: String { get { return array.description }}
    
    
    public init(_ vals:Element..., unsized: Bool = false) {
        self.array = vals
        self.unsized = unsized
    }

    public init<S:Sequence>(with ar:S, unsized: Bool = false) where S.Element == Element {
        self.array = Array(ar)
        self.unsized = unsized
    }


    
    public func expandToArray(size: Int) -> Array<Element> {
        if self.unsized {
            return Array(repeatElement(self.array[0], count: size))
        } else {
            return self.array
        }
    }
}

//extension ZipArray where  Element: Strideable, Element.Stride == Int {
//    public init(_ range: Range<Element>, unsized: Bool = false) {
//        self.init(Array(range), unsized: unsized)
//    }
//}

extension ZipArray : Applicative {
    public static func pure<A>(_ a: A) -> ZipArray<A> {
        return ZipArray<A>(with: [a], unsized: true)
    }
    
    public func ap<B>(_ fAB: ZipArray<(Element) -> B>) -> ZipArray<B> {
        // must expand out the unsized array to the size of the larger array
        let fexp = fAB.expandToArray(size: max(fAB.count, self.count ))
        let aaexp = self.expandToArray(size: max(fAB.count, self.count ))
        
        return  ZipArray<B>(with: zip( fexp, aaexp ).map { f,a in f(a) })
    }
}

extension Construct where ConstructorTag == ZipArrayTag
{
    public var toArray: Array<TypeParameter> { get { return lower.array }}
}
