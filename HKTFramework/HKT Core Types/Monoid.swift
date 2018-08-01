//
//  Monoid.swift
//  HKT
//
//  Created by @strictlyswift on 2/2/18.
//

infix operator <> : AdditionPrecedence

import Foundation

/// Monoids define a "zero", called "id", and an operator <> ("diamond") which is associative.
///
/// In other words:
///
///      id must satisfy:  a <> id == id <> a == a
///      <> must satisfy:  (a <> b) <> c == a <> (b <> c)
public protocol Monoid  {
    // id must satisfy:  a <> id == id <> a == a
    static var id: Self { get }
    
    // <> must satisfy:  (a <> b) <> c == a <> (b <> c)
    static func <>(a: Self, b: Self) -> Self
}


extension Array: Monoid  {
    public static var id: Array<Element> {
        return Array<Element>.init()
    }
    
    public static func <>(a: Array<Element>, b: Array<Element>) -> Array<Element> {
        var mutArray = a
        mutArray.append(contentsOf: b)
        return mutArray
    }
}

extension Int : Monoid   {
    public static var id: Int {
        return 0
    }
    
    public static func <>(a: Int, b: Int) -> Int {
        return a + b
    }
}

extension String: Monoid  {
    public static var id: String {
        return ""
    }
    
    public static func <>(a: String, b: String) -> String {
        return a + b
    }
}

