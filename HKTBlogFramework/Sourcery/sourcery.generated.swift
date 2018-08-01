// Generated using Sourcery 0.10.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import HKTFramework




//MARK: - HKT for Future


/// FutureTag is the container type for values of Future
public struct FutureTag : HKTTag {
    public typealias ActualType = Future
    fileprivate let _actual: Any
    init<T>(_ actual:Future<T>) { self._actual = actual as Any }
}
extension Future : _TypeConstructor {
    public typealias Tag = FutureTag
    
    public var lift: Construct<Tag, TypeParameter> {
        return Construct<Tag, TypeParameter>(tag: Tag(self))
    }
    
    // If you get an error: Method 'lower' in non-final class 'Future<T>' must return 'Self'
    // to conform to protocol '_TypeConstructor', then make Future final
    public static func lower(_ con: Construct<Tag, TypeParameter>) -> Future<TypeParameter> {
        return con.tag._actual as! Future
    }
}



extension Construct where ConstructorTag == FutureTag
{
    public var lower: Future<TypeParameter> { get {
        return Future.lower(self)
        }}
    
    public var toFuture: Future<TypeParameter> { get { return lower }}
}

public func >>>¬<A>(left: Construct<FutureTag, A>, right: @escaping (Construct<FutureTag, A>) -> Future<A>) -> Future<A>
{
    return right(left)
}

public postfix func¬<A>(left: Construct<FutureTag, A>) -> Future<A> {
    return left.lower
}

public func toFuture<A>(_ con:Construct<FutureTag, A>) -> Future<A> {
    return Future<A>.lower(con)
}


extension FutureTag : FunctorTag {
    public static func fmap<A, B>(_ transform: @escaping (A) -> B) -> (Construct<FutureTag, A>) -> Construct<FutureTag, B> {
        return { applyA in
            let a = Future<A>.lower(applyA)
            
            // If you get an error on the next line like "Value of type "Future<A> has no member fmap"  that is
            // because Future conforms to the Functor protocol but does not also implement this method:
            // internal func fmap<B>(_ transform: @escaping (A) -> B) -> Future<B>
            return a.fmap(transform)^
        }
    }
}

public func >>>•<P,Q>(left: Future<P>, right: @escaping (P) -> Q) -> Future<Q>
{
    return left.fmap(right)
}






extension FutureTag : MonadTag {
    
    
    public static func pure<V>(_ v: V) -> Construct<FutureTag, V> {
        
        // If you get an error on the next line like "Value of type "Future<A> has no member pure"  that is
        // because Future conforms to the Monad protocol but does not also implement this method:
        // internal static func pure<V>(_ v: V) -> Future<V>
        
        return Future<V>.pure(v)^
    }
    
    public static func bind<A,B>(_ m:Construct<FutureTag, A> ) -> ( @escaping (A) -> Construct<FutureTag, B>) -> Construct<FutureTag, B> {
        return { fA in
            let ml : Future<A> = Future<A>.lower(m)
            let wa : (A) -> Future<B> = { a in Future<B>.lower(fA(a)) }
            
            // If you get an error on the next line like "Value of type "Future<A> has no member bind"  that is
            // because Future conforms to the Monad protocol but does not also implement this method:
            // internal func bind<B>(_ m: (TypeParameter) -> Future<B>) -> Future<B>
            return ml.bind(wa)^
        }
    }
}

extension Future {
    public static func >>>=<B>( left: Future<TypeParameter>, right: @escaping (TypeParameter) -> Future<B>) -> Future<B> {
        return left.bind(right)
    }
}

public func >=> <A,B,C> (l: @escaping (A) -> Future<B>, r: @escaping (B) -> Future<C> ) -> (A) -> Future<C> {
    return { a in l(a) >>>= r }
}
public func >=> <A,B> (l: A, r: @escaping (A) -> Future<B> ) -> Future<B> {
    return Future<A>.pure(l) >>>= r
}





//MARK: - HKT for LinkedList


/// LinkedListTag is the container type for values of LinkedList
public struct LinkedListTag : HKTTag {
    public typealias ActualType = LinkedList
    fileprivate let _actual: Any
    init<T>(_ actual:LinkedList<T>) { self._actual = actual as Any }
}
extension LinkedList : _TypeConstructor {
    public typealias Tag = LinkedListTag
    
    public var lift: Construct<Tag, TypeParameter> {
        return Construct<Tag, TypeParameter>(tag: Tag(self))
    }
    
    // If you get an error: Method 'lower' in non-final class 'LinkedList<T>' must return 'Self'
    // to conform to protocol '_TypeConstructor', then make LinkedList final
    public static func lower(_ con: Construct<Tag, TypeParameter>) -> LinkedList<TypeParameter> {
        return con.tag._actual as! LinkedList
    }
}



extension Construct where ConstructorTag == LinkedListTag
{
    public var lower: LinkedList<TypeParameter> { get {
        return LinkedList.lower(self)
        }}
    
    public var toLinkedList: LinkedList<TypeParameter> { get { return lower }}
}

public func >>>¬<A>(left: Construct<LinkedListTag, A>, right: @escaping (Construct<LinkedListTag, A>) -> LinkedList<A>) -> LinkedList<A>
{
    return right(left)
}

public postfix func¬<A>(left: Construct<LinkedListTag, A>) -> LinkedList<A> {
    return left.lower
}

public func toLinkedList<A>(_ con:Construct<LinkedListTag, A>) -> LinkedList<A> {
    return LinkedList<A>.lower(con)
}


extension LinkedListTag : FunctorTag {
    public static func fmap<A, B>(_ transform: @escaping (A) -> B) -> (Construct<LinkedListTag, A>) -> Construct<LinkedListTag, B> {
        return { applyA in
            let a = LinkedList<A>.lower(applyA)
            
            // If you get an error on the next line like "Value of type "LinkedList<A> has no member fmap"  that is
            // because LinkedList conforms to the Functor protocol but does not also implement this method:
            // public func fmap<B>(_ transform: @escaping (A) -> B) -> LinkedList<B>
            return a.fmap(transform)^
        }
    }
}

func >>>•<P,Q>(left: LinkedList<P>, right: @escaping (P) -> Q) -> LinkedList<Q>
{
    return left.fmap(right)
}




//MARK: - HKT for Tree


/// TreeTag is the container type for values of Tree
public struct TreeTag : HKTTag {
    public typealias ActualType = Tree
    fileprivate let _actual: Any
    init<T>(_ actual:Tree<T>) { self._actual = actual as Any }
}
extension Tree : _TypeConstructor {
    public typealias Tag = TreeTag
    
    public var lift: Construct<Tag, TypeParameter> {
        return Construct<Tag, TypeParameter>(tag: Tag(self))
    }
    
    public static func lower(_ con: Construct<Tag, TypeParameter>) -> Tree<TypeParameter> {
        return con.tag._actual as! Tree
    }
}



extension Construct where ConstructorTag == TreeTag
{
    public var lower: Tree<TypeParameter> { get {
        return Tree.lower(self)
        }}
    
    public var toTree: Tree<TypeParameter> { get { return lower }}
}

public func >>>¬<A>(left: Construct<TreeTag, A>, right: @escaping (Construct<TreeTag, A>) -> Tree<A>) -> Tree<A>
{
    return right(left)
}

public postfix func¬<A>(left: Construct<TreeTag, A>) -> Tree<A> {
    return left.lower
}

public func toTree<A>(_ con:Construct<TreeTag, A>) -> Tree<A> {
    return Tree<A>.lower(con)
}






//MARK: - HKT for WebData


/// WebDataTag is the container type for values of WebData
public struct WebDataTag : HKTTag {
    public typealias ActualType = WebData
    fileprivate let _actual: Any
    init<T>(_ actual:WebData<T>) { self._actual = actual as Any }
}
extension WebData : _TypeConstructor {
    public typealias Tag = WebDataTag
    
    public var lift: Construct<Tag, TypeParameter> {
        return Construct<Tag, TypeParameter>(tag: Tag(self))
    }
    
    public static func lower(_ con: Construct<Tag, TypeParameter>) -> WebData<TypeParameter> {
        return con.tag._actual as! WebData
    }
}



extension Construct where ConstructorTag == WebDataTag
{
    public var lower: WebData<TypeParameter> { get {
        return WebData.lower(self)
        }}
    
    public var toWebData: WebData<TypeParameter> { get { return lower }}
}

public func >>>¬<A>(left: Construct<WebDataTag, A>, right: @escaping (Construct<WebDataTag, A>) -> WebData<A>) -> WebData<A>
{
    return right(left)
}

public postfix func¬<A>(left: Construct<WebDataTag, A>) -> WebData<A> {
    return left.lower
}

public func toWebData<A>(_ con:Construct<WebDataTag, A>) -> WebData<A> {
    return WebData<A>.lower(con)
}




extension WebDataTag : ApplicativeTag {
    public static func pure<A>(_ a: A) -> Construct<WebDataTag, A> {
        
        // If you get an error on the next line like "Value of type "WebData<A> has no member pure"  that is
        // because WebData conforms to the Applicative protocol but does not also implement this method:
        // internal static func pure<V>(_ v: V) -> WebData<V>
        return WebData<A>.pure(a)^
    }
    
    public static func ap<A, B>(_ fAB: Construct<WebDataTag, (A) -> B>) -> (Construct<WebDataTag, A>) -> Construct<WebDataTag, B> {
        return { fA in
            let fab = WebData<(A)->B>.lower(fAB)
            let wa = WebData<A>.lower(fA)
            
            // If you get an error on the next line like "Value of type "WebData<A> has no member ap"  that is
            // because WebData conforms to the Applicative protocol but does not also implement this method:
            // internal func ap<B>(_ fAB: WebData<(TypeParameter) -> B>) -> WebData<B>
            return wa.ap(fab)^
        }
    }
}

func <*><P,Q>(f: WebData<(P) -> Q>, p: WebData<P>) -> Construct<WebDataTag,Q>
{
    return WebDataTag.ap(f^)(p^)
}
func <*><P,Q>(f: Construct<WebDataTag,(P) -> Q>, p: WebData<P>) -> Construct<WebDataTag,Q>
{
    return WebDataTag.ap(f)(p^)
}

func <¢><P,Q>(f: @escaping (P) -> Q, p: WebData<P>) -> Construct<WebDataTag,Q>
{
    return WebDataTag.ap(WebDataTag.pure(f))(p^)
}

extension Appl2 {
    public subscript(_ first: WebData<A>, _ second: WebData<B> ) -> WebData<C> {
        return appl( f: f2, to: first^, second^ )¬
    }
}
extension Appl3 {
    public subscript(_ first: WebData<A>, _ second: WebData<B>, _ third: WebData<C> ) -> WebData<D> {
        return appl( f: f3, to: first^, second^, third^ )¬
    }
}
extension Appl4 {
    public subscript(_ first: WebData<A>, _ second: WebData<B>, _ third: WebData<C>, _ fourth: WebData<D>  ) -> WebData<E> {
        return appl( f: f4, to: first^, second^, third^, fourth^ )¬
    }
}
extension Appl5 {
    public subscript(_ first: WebData<A>, _ second: WebData<B>, _ third: WebData<C>, _ fourth: WebData<D>, _ fifth: WebData<E>  ) -> WebData<F> {
        return appl( f: f5, to: first^, second^, third^, fourth^, fifth^ )¬
    }
}
extension ApplReduce {
    public subscript(_ params: WebData<Elt>...) -> WebData<Elt> {
        return self.to(params.map(^))¬
    }
}


// Auto-generating Functor instance from Applicative
extension WebData : Functor   {
    public func fmap<B>(_ transform: @escaping (TypeParameter) -> B) -> WebData<B> {
        return self.ap(WebData.pure(transform))
    }
}

extension WebDataTag : FunctorTag {
    public  static func fmap<TypeParameter, B>(_ transform: @escaping (TypeParameter) -> B) -> (Construct<WebDataTag, TypeParameter>) -> Construct<WebDataTag, B> {
        return { applyA in
            let a = WebData<TypeParameter>.lower(applyA)
            return a.fmap(transform)^
        }
    }
}




extension WebDataTag : MonadTag {
    
    // As WebData also implements Applicative, no need to implement pure
    
    
    public  static func bind<A,B>(_ m:Construct<WebDataTag, A> ) -> ( @escaping (A) -> Construct<WebDataTag, B>) -> Construct<WebDataTag, B> {
        return { fA in
            let ml : WebData<A> = WebData<A>.lower(m)
            let wa : (A) -> WebData<B> = { a in WebData<B>.lower(fA(a)) }
            
            // If you get an error on the next line like "Value of type "WebData<A> has no member bind"  that is
            // because WebData conforms to the Monad protocol but does not also implement this method:
            // internal func bind<B>(_ m: (TypeParameter) -> WebData<B>) -> WebData<B>
            return ml.bind(wa)^
        }
    }
}

extension WebData {
    public static func >>>=<B>( left: WebData<TypeParameter>, right: @escaping (TypeParameter) -> WebData<B>) -> WebData<B> {
        return left.bind(right)
    }
}

func >=> <A,B,C> (l: @escaping (A) -> WebData<B>, r: @escaping (B) -> WebData<C> ) -> (A) -> WebData<C> {
    return { a in l(a) >>>= r }
}
func >=> <A,B> (l: A, r: @escaping (A) -> WebData<B> ) -> WebData<B> {
    return WebData<A>.pure(l) >>>= r
}






