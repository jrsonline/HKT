import Foundation
import HKTFramework
import HKTBlogFramework

// Kleisli Categories and Fish

// We can use the fish operator >=> to map between monads
// The motivating example is: look at this monad chain:
func Kleiski1() -> Writer<[String], Pict> {
    return  adjustPicture( do: GreyScaleOperation() )( initialPicture ) >>>= { p1 in
        adjustPicture( do: RotateOperation(angle: 90) )(p1) >>>= { p2 in
            adjustPicture( do: ResizeOperation(scale: 0.5) )(p2)
        }}
}

// Note we put the result of the first "adjustPicture" into p1, then immediately take p1
// and put it into the next "adjustPicture"; and return that in p2 - then we take p2 and
// put it into the next "adjustPicture"

// This sequence of monad operation -> result -> monad operation -> result ...
// ...is very common, so wouldn't it be great if we could simplify the boiler plate >>>= { p1 in ...

// What if we could do this:
// let adjusted =  initialValue <???> operation <???> operation <???> operation <???> ...
// ...where each operation is carried out on the result of the prior operation.
// What would operator <???> have to look like?

// >=> does this exactly:
func Kleiski2() -> Writer<[String], Pict> {
    return  initialPicture >=>
        adjustPicture( do: GreyScaleOperation() ) >=>
        adjustPicture( do: RotateOperation(angle: 90) ) >=>
        adjustPicture( do: ResizeOperation(scale: 0.5) )
}


// >=> is defined quite straightforwardly as "the operator which makes the above work" and it looks
// like this for a monad M
//func >=> <A,B,C> (l: @escaping (A) -> M<B>, r: @escaping (B) -> M<C> ) -> (A) -> M<C> {
//    return { a in l(a) >>>= r }
//}

// In other words it is a bit like "map" (or fmap) for Monads.

// To make life easier, we also define a version which takes just a value on the left-hand side:
//func >=> <A,B> (l: A, r: @escaping (A) -> M<B> ) -> M<B> {
//    return M<A>.pure(l) >>>= r
//}

// We can do other neat things with >=> too:
extension Pict {
    func renderToContext2() -> Reader<OutputContext, Void> {
        return self >=> Pict.toneMapping(d: 0.5) >=> Pict.scaleToFit >=> Pict.performRender
    }
}


// Or what if we have a couple of functions on Optionals:
let asInt : (String) -> Int? = { Int($0) }
let sqRoot : (Int) -> Double? = { $0 >= 0 ? sqrt(Double($0)) : nil }

let sqRootOf : (String) -> Double? = asInt >=> sqRoot
    
"100" >=> sqRootOf
"-100" >=> sqRootOf

typealias Person = String


extension String {
    func ixer( fn: @escaping (Int,String) -> String ) -> [String] {
        return Appl2(fn)[ZipArray(with: 0...self.count), ZipArray<String>.pure(self)].array
    }
    static func prefixes(_ s: String) -> [String] {
        return s.ixer { (n:Int,s:String) in String(s.prefix(n)) }
    }
    
    static func suffixes(_ s: String) -> [String] {
        return s.ixer { (n:Int,s:String) in String(s.suffix(n)) }
    }
    
}
struct FamilyKleisli {
    
    // suppose we have a function from a person to their children:
    static func children(of p: Person) -> [Person] {
        return [p+"dottir", p+"sson", p+"othersson"]
    }
    
    // then :
    static let greatGrandChildren = children >=> children >=> children
}



 ///////// Temporary, remove
 print(  FamilyKleisli.greatGrandChildren("Me")  )
 
 let splitter: (Character) -> (String) -> [String] = { c in { (s:String) in s.split(separator: c).map (String.init) }}
 
 print( "12,34;43,45,33-23,44,58;16;9;4,66-35,36;47,48-2"
 >=> splitter("-")
 >=> splitter(",")
 >=> splitter(";")
 )
 
 
 func pictureComparison( a:Picture, b: Picture ) -> Bool {
 return true
 }
 
 enum StructuredLogger : Monoid, CustomStringConvertible {
 case empty
 case log(String)
 indirect case join(l: StructuredLogger, r: StructuredLogger)
 
 var description: String { get {
 switch self {
 case .empty: return ""
 case let .log(a): return "\"" + a + "\""
 case let .join(.empty,r): return r.description
 case let .join(l,.empty): return l.description
 case let .join(l,r): return "(" + l.description + " then " + r.description + ")"
 }
 }
 }
 
 static var id: StructuredLogger { get { return .empty}}
 
 static func <> (a: StructuredLogger, b: StructuredLogger) -> StructuredLogger {
 return .join(l: a,r: b)
 }
 
 
 }
 
 func adjustPictureSL(do op: PictureOperation) -> (Picture) -> Writer<StructuredLogger, Picture> {
 return { picture in
 return Writer(writing: .log(op.name), value: op.operation(p:picture))
 }
 }
 
 let initialPW = Writer<StructuredLogger,Picture>.pure(initialPicture).write(.log("Initial"))
 
 let adjustedPW : Writer<StructuredLogger,Picture> =
 initialPW >>>=
 adjustPictureSL( do: GreyScaleOperation() ) >=>
 adjustPictureSL( do: RotateOperation(angle: 90) ) >=>
 adjustPictureSL( do: ResizeOperation(scale: 0.5) )
 
 var same = Appl2(pictureComparison)[ initialPW, adjustedPW ]
 same = same.write(.log("Compared pictures and got result \(same.value)"))
 print( same.writing )
 
 // mjoin
 let q = ["1":nil, "2":2, "3":nil]["2"]
 print( q.mjoin() )
 print( q )
 
 let qq = [[1,2],[3,4],[5,6]]
 print( qq.mjoin() )
 
 
 extension Sequence {
 var first : Element?  { get { return self.first(where: {_ in true}) } }
 }
 // mreduce
 extension Sequence {
 
 /*
 filterM          :: (Monad m) => (a -> m Bool) -> [a] -> m [a]
 filterM _ []     =  return []
 filterM p (x:xs) =  do
 flg <- p x
 ys  <- filterM p xs
 return (if flg then x:ys else ys)
 *//*
 func mfilter(_ isIncluded: @escaping (Self.Element)  -> Optional<Bool>)  -> Optional<[Self.Element]> {
 if let s = self.first {
 return isIncluded(s) >>>= { flag in
 self.dropFirst().mfilter(isIncluded) >>>= { ys in
 .pure( flag ? ([s] + ys) : ys )
 }
 }
 } else {
 return .pure([])
 }
 }
 func mfilter<FixedType>(_ isIncluded: @escaping (Self.Element)  -> Writer<FixedType,Bool>)  -> Writer<FixedType,[Self.Element]> {
 if let s = self.first {
 return isIncluded(s) >>>= { flag in
 self.dropFirst().mfilter(isIncluded) >>>= { ys in
 .pure( flag ? ([s] + ys) : ys )
 }
 }
 } else {
 return .pure([])
 }
 }*/
 }
 
 
 let sumPositive : (Int,Int) -> Int? = { (acc,x) in
 guard x>=0 else { return nil }
 return (acc+x)
 }
 
 // On the face of it not too different, but note sumPositive is now an non-total function - might fail!
 let sumPositive2 : (Int?,Int) -> Int? = { (acc,x) in
 guard x>=0 else { return nil }
 guard let acc = acc else { fatalError("Accumulator can't be nil !") }  // avoid nasty surprises
 return (acc+x)
 }
 
 print( [2,4,6].mreduce(0,sumPositive)  )
 print( [2,4,-6].mreduce(0,sumPositive)  )
 print( [2,4,-6].reduce(0,sumPositive2)  )
 
 // better with WebData  ?
 // where is Either type
 
 func keepSmall(i:Int) -> Writer<[String], Bool> {
 switch i {
 case ...4: return Writer(writing:["Keeping \(i)"], value:true)
 default: return Writer(writing: ["\(i) is too large, ignoring"], value: false)
 }
 }
 
 print( [5,3,6,1,4,3].mfilter(keepSmall))
 
 func powerset<A>(_ xs:[A]) -> [[A]] {
 return xs.mfilter( {x in [true,false]} )
 }
 
 print( powerset([1,2,3]) )
 
 
 // Knight Moves
 /*
 type KnightPos = (Int,Int)
 moveKnight :: KnightPos -> [KnightPos]
 moveKnight (c,r) = do
 (c',r') <- [(c+2,r-1),(c+2,r+1),(c-2,r-1),(c-2,r+1)
 ,(c+1,r-2),(c+1,r+2),(c-1,r-2),(c-1,r+2)
 ]
 guard (c' `elem` [1..8] && r' `elem` [1..8])
 return (c',r')
 
 in3 :: KnightPos -> [KnightPos]
 in3 start = do
 first <- moveKnight start
 second <- moveKnight first
 moveKnight second
 
 canReachIn3 :: KnightPos -> KnightPos -> Bool
 canReachIn3 start end = end `elem` in3 start
 */
 
 typealias KnightPos = (Int,Int)
 
 func moveKnight(from: KnightPos) -> [KnightPos] {
 let (c,r) = from
 return [(c+2,r-1),(c+2,r+1),(c-2,r-1),(c-2,r+1)
 ,(c+1,r-2),(c+1,r+2),(c-1,r-2),(c-1,r+2)]
 .filter { mvs in mvs.0 >= 1 && mvs.0 <= 8 && mvs.1 >= 1 && mvs.1 <= 8 }
 }
 
 func in3(from: KnightPos) -> LazyCollection<[KnightPos]> {
 return (from >=> moveKnight >=> moveKnight >=> moveKnight).lazy
 }
 
 func canReachIn3(from: KnightPos, to: KnightPos) -> Bool {
 return in3(from: from).contains { pos in pos.0 == to.0 && pos.1 == to.1 }
 }
 
 
 print( canReachIn3(from: (6,2), to: (6,3)) )
 print( canReachIn3(from: (6,2), to: (7,3)) )
 
 typealias KnightMove = (KnightPos) ->[KnightPos]
 func inMany(n: Int, from: KnightPos) -> [KnightPos] {
 let moves = Array.init(repeating: moveKnight, count: n)
 
 return [from] >>>= moves.reduce(Array<KnightMove>.pure, (>=>))
 }
 
 func canReachIn(n:Int, from: KnightPos, to: KnightPos) -> Bool {
 return inMany(n: n, from: from).contains { pos in pos.0 == to.0 && pos.1 == to.1 }
 }
 
 print( canReachIn(n:3, from: (6,2), to: (6,3)) )
 print( canReachIn(n:2, from: (6,2), to: (6,3)) )
 print( canReachIn(n:4, from: (6,2), to: (7,3)) )
 
 
 

