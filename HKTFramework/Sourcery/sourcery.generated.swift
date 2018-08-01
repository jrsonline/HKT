// Generated using Sourcery 0.10.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT









//MARK: - HKT for Array  

/// ArrayTag is the container type for values of Array
public struct  ArrayTag : HKTTag  {
	public typealias ActualType = Array
	fileprivate let _actual: Any
	public init<T>(_ actual:Array<T>) { self._actual = actual as Any }
}

extension Array : _TypeConstructor {
	public typealias Tag = ArrayTag
	public var lift: Construct<Tag, TypeParameter> {
		return Construct<Tag, TypeParameter>(tag: Tag(self))
	}

	public static func lower(_ con: Construct<Tag, TypeParameter>) -> Array<TypeParameter> {
	return con.tag._actual as! Array  
	}
}

extension Construct where ConstructorTag == ArrayTag
{
	public var lower: Array<TypeParameter> { get {
		return Array<TypeParameter>.lower(self)
	}}
public var toArray: Array<TypeParameter> { get { return lower }}

}

public func >>>¬<A>(left: Construct<ArrayTag,A>, right: @escaping (Construct<ArrayTag,A>) -> Array<A>) -> Array<A>
{
	return right(left)
}

public postfix func¬<A>(left: Construct<ArrayTag,A>) -> Array<A> {
	return Array.lower(left)
}

public func toArray<A>(_ con:Construct<ArrayTag,A>) -> Array<A> {
	return Array<A>.lower(con)
}







extension ArrayTag : ApplicativeTag {
	public static func pure<A>(_ a: A) -> Construct<ArrayTag,A> {

// If you get an error on the next line like "Value of type "Array<A> has no member pure"  that is
// because Array conforms to the Applicative protocol but does not also implement this method:
// public static func pure<V>(_ v: V) -> Array<V>
		return Array<A>.pure(a)^
	}

	public static func ap<A, B>(_ fAB: Construct<ArrayTag,(A) -> B>) -> (Construct<ArrayTag,A>) -> Construct<ArrayTag,B> {
		return { fA in
			let fab = Array<(A) -> B>.lower(fAB)
			let wa = Array<A>.lower(fA)

			// If you get an error on the next line like "Value of type "Array<A> has no member ap"  that is
			// because Array conforms to the Applicative protocol but does not also implement this method:
			// public func ap<B>(_ fAB: Array<(TypeParameter) -> B>) -> Array<B>
			return wa.ap(fab)^
		}
	}
}

public func <*><P,Q>(f: Array<(P) -> Q>, p: Array<P>) -> Construct<ArrayTag,Q>
{
	return ArrayTag.ap(f^)(p^)
}
public func <*><P,Q>(f: Construct<ArrayTag,(P) -> Q>, p: Array<P>) -> Construct<ArrayTag,Q>
{
	return ArrayTag.ap(f)(p^)
}

public func <¢><P,Q>(f: @escaping (P) -> Q, p: Array<P>) -> Construct<ArrayTag,Q>
{
	return ArrayTag.ap(ArrayTag.pure(f))(p^)
}

extension Appl2 {
	public subscript(_ first: Array<A>, _ second: Array<B> ) -> Array<C> {
		return appl( f: f2, to: first^, second^ )¬
	}
}
extension Appl3 {
	public subscript(_ first: Array<A>, _ second: Array<B>, _ third: Array<C> ) -> Array<D> {
		return appl( f: f3, to: first^, second^, third^ )¬
	}
}
extension Appl4 {
	public subscript(_ first: Array<A>, _ second: Array<B>, _ third: Array<C>, _ fourth: Array<D>  ) -> Array<E> {
		return appl( f: f4, to: first^, second^, third^, fourth^ )¬
	}
}
extension Appl5 {
	public subscript(_ first: Array<A>, _ second: Array<B>, _ third: Array<C>, _ fourth: Array<D>, _ fifth: Array<E>  ) -> Array<F> {
		return appl( f: f5, to: first^, second^, third^, fourth^, fifth^ )¬
	}
}
extension ApplReduce {
	public subscript(_ params: Array<Elt>...) -> Array<Elt> {
		return self.to(params.map(^))¬
	}
}


// Auto-generating Functor instance from Applicative
extension Array : Functor   {
	public func fmap<B>(_ transform: @escaping (TypeParameter) -> B) -> Array<B> {
		return self.ap(Array.pure(transform))
	}
}

extension ArrayTag : FunctorTag {
	public static func fmap<TypeParameter, B>(_ transform: @escaping (TypeParameter) -> B) -> (Construct<ArrayTag,TypeParameter>) -> Construct<ArrayTag,B> {
		return { applyA in
			let a = Array<TypeParameter>.lower(applyA)
			return a.fmap(transform)^
		}
	}
}




extension ArrayTag : MonadTag {


	public static func bind<A,B>(_ m:Construct<ArrayTag,A> ) -> ( @escaping (A) -> Construct<ArrayTag,B>) -> Construct<ArrayTag,B> {
		return { fA in
			let ml : Array<A> = Array<A>.lower(m)
			let wa : (A) -> Array<B> = { a in Array<B>.lower(fA(a)) }

			// If you get an error on the next line like "Value of type "Array<A> has no member bind"  that is
			// because Array conforms to the Monad protocol but does not also implement this method:
			// public func bind<B>(_ m: (TypeParameter) -> Array<B>) -> Array<B>
			return ml.bind(wa)^
		}
	}
}

extension Array {
	public static func >>>=<B>( left: Array<TypeParameter>, right: @escaping (TypeParameter) -> Array<B>) -> Array<B> {
		return left.bind(right)
	}
}

public func >=> <A,B,C>(l: @escaping (A) -> Array<B>, r: @escaping (B) -> Array<C> ) -> (A) -> Array<C> {
	return { a in l(a) >>>= r }
}
public func <=< <A,B,C>(l: @escaping (B) -> Array<C>, r: @escaping (A) -> Array<B> ) -> (A) -> Array<C> {
return { a in r(a) >>>= l }
}

public func >=> <A,B> (l: A, r: @escaping (A) -> Array<B> ) -> Array<B> {
	return Array<A>.pure(l) >>>= r
}

// mjoin implementation for free
extension Array {
	public func mjoin<T>() -> Array<T> where TypeParameter == Array<T> {
		return self >>>= { $0 }
	}
}
// Sequence functions we get from a Monad for free
extension Sequence {
    public func mreduce<TypeParameter,Result>(_ initialResult: Result, _ f: @escaping (Result, TypeParameter) -> Array<Result>) -> Array<Result> where Element == TypeParameter {
        if let s = self.first {
            return f(initialResult,s) >>>= { p in self.dropFirst().mreduce(p, f) }
        } else {
            return .pure(initialResult)
        }
    }

    public func mfilter(_ isIncluded: @escaping (Self.Element)  -> Array<Bool>)  -> Array<[Self.Element]> {
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
}






//MARK: - HKT for Either  internal

/// EitherTag is the container type for values of Either
public struct EitherTag<FixedType> : HKTTag  {
	public typealias ActualType<A> = Either<FixedType,A>
	fileprivate let _actual: Any
	public init<FixedType,T>(_ actual:Either<FixedType,T>) { self._actual = actual as Any }
}

extension Either : _TypeConstructor {
	public typealias Tag = EitherTag<FixedType>
	public var lift: Construct<Tag, TypeParameter> {
		return Construct<Tag, TypeParameter>(tag: Tag(self))
	}

	public static func lower(_ con: Construct<Tag, TypeParameter>) -> Either<FixedType, TypeParameter> {
	return con.tag._actual as! Either  
	}
}


public func >>>¬<FixedType,A>(left: Construct<EitherTag<FixedType>,A>, right: @escaping (Construct<EitherTag<FixedType>,A>) -> Either<FixedType, A>) -> Either<FixedType, A>
{
	return right(left)
}

public postfix func¬<FixedType,A>(left: Construct<EitherTag<FixedType>,A>) -> Either<FixedType, A> {
	return Either.lower(left)
}

public func toEither<FixedType, A>(_ con:Construct<EitherTag<FixedType>,A>) -> Either<FixedType, A> {
	return Either<FixedType, A>.lower(con)
}


extension EitherTag : FunctorTag {
	public static func fmap<A, B>(_ transform: @escaping (A) -> B) -> (Construct<EitherTag<FixedType>,A>) -> Construct<EitherTag<FixedType>,B> {
	return { applyA in
		let a = Either<FixedType, A>.lower(applyA)

// If you get an error on the next line like "Value of type "Either<A> has no member fmap"  that is
// because Either conforms to the Functor protocol but does not also implement this method:
// public func fmap<B>(_ transform: @escaping (A) -> B) -> Either<B>
		return a.fmap(transform)^
	}
	}
}

public func >>>•<FixedType,P,Q>(left: Either<FixedType, P>, right: @escaping (P) -> Q) -> Either<FixedType, Q>
{
	return left.fmap(right)
}








extension EitherTag : ApplicativeTag {
	public static func pure<A>(_ a: A) -> Construct<EitherTag<FixedType>,A> {

// If you get an error on the next line like "Value of type "Either<A> has no member pure"  that is
// because Either conforms to the Applicative protocol but does not also implement this method:
// public static func pure<V>(_ v: V) -> Either<V>
		return Either<FixedType, A>.pure(a)^
	}

	public static func ap<A, B>(_ fAB: Construct<EitherTag<FixedType>,(A) -> B>) -> (Construct<EitherTag<FixedType>,A>) -> Construct<EitherTag<FixedType>,B> {
		return { fA in
			let fab = Either<FixedType, (A) -> B>.lower(fAB)
			let wa = Either<FixedType, A>.lower(fA)

			// If you get an error on the next line like "Value of type "Either<A> has no member ap"  that is
			// because Either conforms to the Applicative protocol but does not also implement this method:
			// public func ap<B>(_ fAB: Either<(TypeParameter) -> B>) -> Either<B>
			return wa.ap(fab)^
		}
	}
}

public func <*><FixedType,P,Q>(f: Either<FixedType, (P) -> Q>, p: Either<FixedType, P>) -> Construct<EitherTag<FixedType>,Q>
{
	return EitherTag.ap(f^)(p^)
}
public func <*><FixedType,P,Q>(f: Construct<EitherTag<FixedType>,(P) -> Q>, p: Either<FixedType, P>) -> Construct<EitherTag<FixedType>,Q>
{
	return EitherTag.ap(f)(p^)
}

public func <¢><FixedType,P,Q>(f: @escaping (P) -> Q, p: Either<FixedType, P>) -> Construct<EitherTag<FixedType>,Q>
{
	return EitherTag.ap(EitherTag.pure(f))(p^)
}

extension Appl2 {
	public subscript<FixedType>(_ first: Either<FixedType, A>, _ second: Either<FixedType, B> ) -> Either<FixedType, C> {
		return appl( f: f2, to: first^, second^ )¬
	}
}
extension Appl3 {
	public subscript<FixedType>(_ first: Either<FixedType, A>, _ second: Either<FixedType, B>, _ third: Either<FixedType, C> ) -> Either<FixedType, D> {
		return appl( f: f3, to: first^, second^, third^ )¬
	}
}
extension Appl4 {
	public subscript<FixedType>(_ first: Either<FixedType, A>, _ second: Either<FixedType, B>, _ third: Either<FixedType, C>, _ fourth: Either<FixedType, D>  ) -> Either<FixedType, E> {
		return appl( f: f4, to: first^, second^, third^, fourth^ )¬
	}
}
extension Appl5 {
	public subscript<FixedType>(_ first: Either<FixedType, A>, _ second: Either<FixedType, B>, _ third: Either<FixedType, C>, _ fourth: Either<FixedType, D>, _ fifth: Either<FixedType, E>  ) -> Either<FixedType, F> {
		return appl( f: f5, to: first^, second^, third^, fourth^, fifth^ )¬
	}
}
extension ApplReduce {
	public subscript<FixedType>(_ params: Either<FixedType, Elt>...) -> Either<FixedType, Elt> {
		return self.to(params.map(^))¬
	}
}




extension EitherTag : MonadTag {


	public static func bind<A,B>(_ m:Construct<EitherTag<FixedType>,A> ) -> ( @escaping (A) -> Construct<EitherTag<FixedType>,B>) -> Construct<EitherTag<FixedType>,B> {
		return { fA in
			let ml : Either<FixedType, A> = Either<FixedType, A>.lower(m)
			let wa : (A) -> Either<FixedType, B> = { a in Either<FixedType, B>.lower(fA(a)) }

			// If you get an error on the next line like "Value of type "Either<A> has no member bind"  that is
			// because Either conforms to the Monad protocol but does not also implement this method:
			// public func bind<B>(_ m: (TypeParameter) -> Either<B>) -> Either<B>
			return ml.bind(wa)^
		}
	}
}

extension Either {
	public static func >>>=<B>( left: Either<FixedType, TypeParameter>, right: @escaping (TypeParameter) -> Either<FixedType, B>) -> Either<FixedType, B> {
		return left.bind(right)
	}
}

public func >=> <FixedType,A,B,C>(l: @escaping (A) -> Either<FixedType, B>, r: @escaping (B) -> Either<FixedType, C> ) -> (A) -> Either<FixedType, C> {
	return { a in l(a) >>>= r }
}
public func <=< <FixedType,A,B,C>(l: @escaping (B) -> Either<FixedType, C>, r: @escaping (A) -> Either<FixedType, B> ) -> (A) -> Either<FixedType, C> {
return { a in r(a) >>>= l }
}

public func >=> <FixedType,A,B> (l: A, r: @escaping (A) -> Either<FixedType, B> ) -> Either<FixedType, B> {
	return Either<FixedType, A>.pure(l) >>>= r
}

// mjoin implementation for free
extension Either {
	public func mjoin<T>() -> Either<FixedType, T> where TypeParameter == Either<FixedType, T> {
		return self >>>= { $0 }
	}
}
// Sequence functions we get from a Monad for free
extension Sequence {
    public func mreduce<FixedType,TypeParameter,Result>(_ initialResult: Result, _ f: @escaping (Result, TypeParameter) -> Either<FixedType, Result>) -> Either<FixedType, Result> where Element == TypeParameter {
        if let s = self.first {
            return f(initialResult,s) >>>= { p in self.dropFirst().mreduce(p, f) }
        } else {
            return .pure(initialResult)
        }
    }

    public func mfilter<FixedType>(_ isIncluded: @escaping (Self.Element)  -> Either<FixedType, Bool>)  -> Either<FixedType, [Self.Element]> {
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
}






//MARK: - HKT for Optional  

/// OptionalTag is the container type for values of Optional
public struct  OptionalTag : HKTTag  {
	public typealias ActualType = Optional
	fileprivate let _actual: Any
	public init<T>(_ actual:Optional<T>) { self._actual = actual as Any }
}

extension Optional : _TypeConstructor {
	public typealias Tag = OptionalTag
	public var lift: Construct<Tag, TypeParameter> {
		return Construct<Tag, TypeParameter>(tag: Tag(self))
	}

	public static func lower(_ con: Construct<Tag, TypeParameter>) -> Optional<TypeParameter> {
	return con.tag._actual as? Wrapped  
	}
}

extension Construct where ConstructorTag == OptionalTag
{
	public var lower: Optional<TypeParameter> { get {
		return Optional<TypeParameter>.lower(self)
	}}
public var toOptional: Optional<TypeParameter> { get { return lower }}

}

public func >>>¬<A>(left: Construct<OptionalTag,A>, right: @escaping (Construct<OptionalTag,A>) -> Optional<A>) -> Optional<A>
{
	return right(left)
}

public postfix func¬<A>(left: Construct<OptionalTag,A>) -> Optional<A> {
	return Optional.lower(left)
}

public func toOptional<A>(_ con:Construct<OptionalTag,A>) -> Optional<A> {
	return Optional<A>.lower(con)
}







extension OptionalTag : ApplicativeTag {
	public static func pure<A>(_ a: A) -> Construct<OptionalTag,A> {

// If you get an error on the next line like "Value of type "Optional<A> has no member pure"  that is
// because Optional conforms to the Applicative protocol but does not also implement this method:
// public static func pure<V>(_ v: V) -> Optional<V>
		return Optional<A>.pure(a)^
	}

	public static func ap<A, B>(_ fAB: Construct<OptionalTag,(A) -> B>) -> (Construct<OptionalTag,A>) -> Construct<OptionalTag,B> {
		return { fA in
			let fab = Optional<(A) -> B>.lower(fAB)
			let wa = Optional<A>.lower(fA)

			// If you get an error on the next line like "Value of type "Optional<A> has no member ap"  that is
			// because Optional conforms to the Applicative protocol but does not also implement this method:
			// public func ap<B>(_ fAB: Optional<(TypeParameter) -> B>) -> Optional<B>
			return wa.ap(fab)^
		}
	}
}

public func <*><P,Q>(f: Optional<(P) -> Q>, p: Optional<P>) -> Construct<OptionalTag,Q>
{
	return OptionalTag.ap(f^)(p^)
}
public func <*><P,Q>(f: Construct<OptionalTag,(P) -> Q>, p: Optional<P>) -> Construct<OptionalTag,Q>
{
	return OptionalTag.ap(f)(p^)
}

public func <¢><P,Q>(f: @escaping (P) -> Q, p: Optional<P>) -> Construct<OptionalTag,Q>
{
	return OptionalTag.ap(OptionalTag.pure(f))(p^)
}

extension Appl2 {
	public subscript(_ first: Optional<A>, _ second: Optional<B> ) -> Optional<C> {
		return appl( f: f2, to: first^, second^ )¬
	}
}
extension Appl3 {
	public subscript(_ first: Optional<A>, _ second: Optional<B>, _ third: Optional<C> ) -> Optional<D> {
		return appl( f: f3, to: first^, second^, third^ )¬
	}
}
extension Appl4 {
	public subscript(_ first: Optional<A>, _ second: Optional<B>, _ third: Optional<C>, _ fourth: Optional<D>  ) -> Optional<E> {
		return appl( f: f4, to: first^, second^, third^, fourth^ )¬
	}
}
extension Appl5 {
	public subscript(_ first: Optional<A>, _ second: Optional<B>, _ third: Optional<C>, _ fourth: Optional<D>, _ fifth: Optional<E>  ) -> Optional<F> {
		return appl( f: f5, to: first^, second^, third^, fourth^, fifth^ )¬
	}
}
extension ApplReduce {
	public subscript(_ params: Optional<Elt>...) -> Optional<Elt> {
		return self.to(params.map(^))¬
	}
}


// Auto-generating Functor instance from Applicative
extension Optional : Functor   {
	public func fmap<B>(_ transform: @escaping (TypeParameter) -> B) -> Optional<B> {
		return self.ap(Optional.pure(transform))
	}
}

extension OptionalTag : FunctorTag {
	public static func fmap<TypeParameter, B>(_ transform: @escaping (TypeParameter) -> B) -> (Construct<OptionalTag,TypeParameter>) -> Construct<OptionalTag,B> {
		return { applyA in
			let a = Optional<TypeParameter>.lower(applyA)
			return a.fmap(transform)^
		}
	}
}




extension OptionalTag : MonadTag {


	public static func bind<A,B>(_ m:Construct<OptionalTag,A> ) -> ( @escaping (A) -> Construct<OptionalTag,B>) -> Construct<OptionalTag,B> {
		return { fA in
			let ml : Optional<A> = Optional<A>.lower(m)
			let wa : (A) -> Optional<B> = { a in Optional<B>.lower(fA(a)) }

			// If you get an error on the next line like "Value of type "Optional<A> has no member bind"  that is
			// because Optional conforms to the Monad protocol but does not also implement this method:
			// public func bind<B>(_ m: (TypeParameter) -> Optional<B>) -> Optional<B>
			return ml.bind(wa)^
		}
	}
}

extension Optional {
	public static func >>>=<B>( left: Optional<TypeParameter>, right: @escaping (TypeParameter) -> Optional<B>) -> Optional<B> {
		return left.bind(right)
	}
}

public func >=> <A,B,C>(l: @escaping (A) -> Optional<B>, r: @escaping (B) -> Optional<C> ) -> (A) -> Optional<C> {
	return { a in l(a) >>>= r }
}
public func <=< <A,B,C>(l: @escaping (B) -> Optional<C>, r: @escaping (A) -> Optional<B> ) -> (A) -> Optional<C> {
return { a in r(a) >>>= l }
}

public func >=> <A,B> (l: A, r: @escaping (A) -> Optional<B> ) -> Optional<B> {
	return Optional<A>.pure(l) >>>= r
}

// mjoin implementation for free
extension Optional {
	public func mjoin<T>() -> Optional<T> where TypeParameter == Optional<T> {
		return self >>>= { $0 }
	}
}
// Sequence functions we get from a Monad for free
extension Sequence {
    public func mreduce<TypeParameter,Result>(_ initialResult: Result, _ f: @escaping (Result, TypeParameter) -> Optional<Result>) -> Optional<Result> where Element == TypeParameter {
        if let s = self.first {
            return f(initialResult,s) >>>= { p in self.dropFirst().mreduce(p, f) }
        } else {
            return .pure(initialResult)
        }
    }

    public func mfilter(_ isIncluded: @escaping (Self.Element)  -> Optional<Bool>)  -> Optional<[Self.Element]> {
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
}






//MARK: - HKT for Reader  internal

/// ReaderTag is the container type for values of Reader
public struct ReaderTag<FixedType> : HKTTag  {
	public typealias ActualType<A> = Reader<FixedType,A>
	fileprivate let _actual: Any
	public init<FixedType,T>(_ actual:Reader<FixedType,T>) { self._actual = actual as Any }
}

extension Reader : _TypeConstructor {
	public typealias Tag = ReaderTag<FixedType>
	public var lift: Construct<Tag, TypeParameter> {
		return Construct<Tag, TypeParameter>(tag: Tag(self))
	}

	public static func lower(_ con: Construct<Tag, TypeParameter>) -> Reader<FixedType, TypeParameter> {
	return con.tag._actual as! Reader  
	}
}


public func >>>¬<FixedType,A>(left: Construct<ReaderTag<FixedType>,A>, right: @escaping (Construct<ReaderTag<FixedType>,A>) -> Reader<FixedType, A>) -> Reader<FixedType, A>
{
	return right(left)
}

public postfix func¬<FixedType,A>(left: Construct<ReaderTag<FixedType>,A>) -> Reader<FixedType, A> {
	return Reader.lower(left)
}

public func toReader<FixedType, A>(_ con:Construct<ReaderTag<FixedType>,A>) -> Reader<FixedType, A> {
	return Reader<FixedType, A>.lower(con)
}


extension ReaderTag : FunctorTag {
	public static func fmap<A, B>(_ transform: @escaping (A) -> B) -> (Construct<ReaderTag<FixedType>,A>) -> Construct<ReaderTag<FixedType>,B> {
	return { applyA in
		let a = Reader<FixedType, A>.lower(applyA)

// If you get an error on the next line like "Value of type "Reader<A> has no member fmap"  that is
// because Reader conforms to the Functor protocol but does not also implement this method:
// public func fmap<B>(_ transform: @escaping (A) -> B) -> Reader<B>
		return a.fmap(transform)^
	}
	}
}

public func >>>•<FixedType,P,Q>(left: Reader<FixedType, P>, right: @escaping (P) -> Q) -> Reader<FixedType, Q>
{
	return left.fmap(right)
}






extension Reader: Applicative {
   public  static func apLift<FixedType,A,B>(_ fAB: Reader<FixedType, (A) -> B>) -> (Reader<FixedType, A>) -> Reader<FixedType, B> {
        return { m in
            fAB >>>= { f in m >>>= { x in Reader<FixedType, B>.pure( f(x) ) }}
        }
    }

   public func ap<B>(_ fAB: Reader<FixedType, (TypeParameter) -> B> ) -> Reader<FixedType, B> {
        return Reader<FixedType, B>.apLift(fAB)(self)
    }
}


extension ReaderTag : ApplicativeTag {
	public static func pure<A>(_ a: A) -> Construct<ReaderTag<FixedType>,A> {

// If you get an error on the next line like "Value of type "Reader<A> has no member pure"  that is
// because Reader conforms to the Applicative protocol but does not also implement this method:
// public static func pure<V>(_ v: V) -> Reader<V>
		return Reader<FixedType, A>.pure(a)^
	}

	public static func ap<A, B>(_ fAB: Construct<ReaderTag<FixedType>,(A) -> B>) -> (Construct<ReaderTag<FixedType>,A>) -> Construct<ReaderTag<FixedType>,B> {
		return { fA in
			let fab = Reader<FixedType, (A) -> B>.lower(fAB)
			let wa = Reader<FixedType, A>.lower(fA)

			// If you get an error on the next line like "Value of type "Reader<A> has no member ap"  that is
			// because Reader conforms to the Applicative protocol but does not also implement this method:
			// public func ap<B>(_ fAB: Reader<(TypeParameter) -> B>) -> Reader<B>
			return wa.ap(fab)^
		}
	}
}

public func <*><FixedType,P,Q>(f: Reader<FixedType, (P) -> Q>, p: Reader<FixedType, P>) -> Construct<ReaderTag<FixedType>,Q>
{
	return ReaderTag.ap(f^)(p^)
}
public func <*><FixedType,P,Q>(f: Construct<ReaderTag<FixedType>,(P) -> Q>, p: Reader<FixedType, P>) -> Construct<ReaderTag<FixedType>,Q>
{
	return ReaderTag.ap(f)(p^)
}

public func <¢><FixedType,P,Q>(f: @escaping (P) -> Q, p: Reader<FixedType, P>) -> Construct<ReaderTag<FixedType>,Q>
{
	return ReaderTag.ap(ReaderTag.pure(f))(p^)
}

extension Appl2 {
	public subscript<FixedType>(_ first: Reader<FixedType, A>, _ second: Reader<FixedType, B> ) -> Reader<FixedType, C> {
		return appl( f: f2, to: first^, second^ )¬
	}
}
extension Appl3 {
	public subscript<FixedType>(_ first: Reader<FixedType, A>, _ second: Reader<FixedType, B>, _ third: Reader<FixedType, C> ) -> Reader<FixedType, D> {
		return appl( f: f3, to: first^, second^, third^ )¬
	}
}
extension Appl4 {
	public subscript<FixedType>(_ first: Reader<FixedType, A>, _ second: Reader<FixedType, B>, _ third: Reader<FixedType, C>, _ fourth: Reader<FixedType, D>  ) -> Reader<FixedType, E> {
		return appl( f: f4, to: first^, second^, third^, fourth^ )¬
	}
}
extension Appl5 {
	public subscript<FixedType>(_ first: Reader<FixedType, A>, _ second: Reader<FixedType, B>, _ third: Reader<FixedType, C>, _ fourth: Reader<FixedType, D>, _ fifth: Reader<FixedType, E>  ) -> Reader<FixedType, F> {
		return appl( f: f5, to: first^, second^, third^, fourth^, fifth^ )¬
	}
}
extension ApplReduce {
	public subscript<FixedType>(_ params: Reader<FixedType, Elt>...) -> Reader<FixedType, Elt> {
		return self.to(params.map(^))¬
	}
}




extension ReaderTag : MonadTag {


	public static func bind<A,B>(_ m:Construct<ReaderTag<FixedType>,A> ) -> ( @escaping (A) -> Construct<ReaderTag<FixedType>,B>) -> Construct<ReaderTag<FixedType>,B> {
		return { fA in
			let ml : Reader<FixedType, A> = Reader<FixedType, A>.lower(m)
			let wa : (A) -> Reader<FixedType, B> = { a in Reader<FixedType, B>.lower(fA(a)) }

			// If you get an error on the next line like "Value of type "Reader<A> has no member bind"  that is
			// because Reader conforms to the Monad protocol but does not also implement this method:
			// public func bind<B>(_ m: (TypeParameter) -> Reader<B>) -> Reader<B>
			return ml.bind(wa)^
		}
	}
}

extension Reader {
	public static func >>>=<B>( left: Reader<FixedType, TypeParameter>, right: @escaping (TypeParameter) -> Reader<FixedType, B>) -> Reader<FixedType, B> {
		return left.bind(right)
	}
}

public func >=> <FixedType,A,B,C>(l: @escaping (A) -> Reader<FixedType, B>, r: @escaping (B) -> Reader<FixedType, C> ) -> (A) -> Reader<FixedType, C> {
	return { a in l(a) >>>= r }
}
public func <=< <FixedType,A,B,C>(l: @escaping (B) -> Reader<FixedType, C>, r: @escaping (A) -> Reader<FixedType, B> ) -> (A) -> Reader<FixedType, C> {
return { a in r(a) >>>= l }
}

public func >=> <FixedType,A,B> (l: A, r: @escaping (A) -> Reader<FixedType, B> ) -> Reader<FixedType, B> {
	return Reader<FixedType, A>.pure(l) >>>= r
}

// mjoin implementation for free
extension Reader {
	public func mjoin<T>() -> Reader<FixedType, T> where TypeParameter == Reader<FixedType, T> {
		return self >>>= { $0 }
	}
}
// Sequence functions we get from a Monad for free
extension Sequence {
    public func mreduce<FixedType,TypeParameter,Result>(_ initialResult: Result, _ f: @escaping (Result, TypeParameter) -> Reader<FixedType, Result>) -> Reader<FixedType, Result> where Element == TypeParameter {
        if let s = self.first {
            return f(initialResult,s) >>>= { p in self.dropFirst().mreduce(p, f) }
        } else {
            return .pure(initialResult)
        }
    }

    public func mfilter<FixedType>(_ isIncluded: @escaping (Self.Element)  -> Reader<FixedType, Bool>)  -> Reader<FixedType, [Self.Element]> {
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
}






//MARK: - HKT for Writer  internal

/// WriterTag is the container type for values of Writer
public struct WriterTag<FixedType: Monoid > : HKTTag  {
	public typealias ActualType<A> = Writer<FixedType,A>
	fileprivate let _actual: Any
	public init<FixedType,T>(_ actual:Writer<FixedType,T>) { self._actual = actual as Any }
}

extension Writer : _TypeConstructor {
	public typealias Tag = WriterTag<FixedType>
	public var lift: Construct<Tag, TypeParameter> {
		return Construct<Tag, TypeParameter>(tag: Tag(self))
	}

	public static func lower(_ con: Construct<Tag, TypeParameter>) -> Writer<FixedType, TypeParameter> {
	return con.tag._actual as! Writer  
	}
}


public func >>>¬<FixedType,A>(left: Construct<WriterTag<FixedType>,A>, right: @escaping (Construct<WriterTag<FixedType>,A>) -> Writer<FixedType, A>) -> Writer<FixedType, A>
{
	return right(left)
}

public postfix func¬<FixedType,A>(left: Construct<WriterTag<FixedType>,A>) -> Writer<FixedType, A> {
	return Writer.lower(left)
}

public func toWriter<FixedType, A>(_ con:Construct<WriterTag<FixedType>,A>) -> Writer<FixedType, A> {
	return Writer<FixedType, A>.lower(con)
}


extension WriterTag : FunctorTag {
	public static func fmap<A, B>(_ transform: @escaping (A) -> B) -> (Construct<WriterTag<FixedType>,A>) -> Construct<WriterTag<FixedType>,B> {
	return { applyA in
		let a = Writer<FixedType, A>.lower(applyA)

// If you get an error on the next line like "Value of type "Writer<A> has no member fmap"  that is
// because Writer conforms to the Functor protocol but does not also implement this method:
// public func fmap<B>(_ transform: @escaping (A) -> B) -> Writer<B>
		return a.fmap(transform)^
	}
	}
}

public func >>>•<FixedType,P,Q>(left: Writer<FixedType, P>, right: @escaping (P) -> Q) -> Writer<FixedType, Q>
{
	return left.fmap(right)
}






extension Writer: Applicative {
   public  static func apLift<FixedType,A,B>(_ fAB: Writer<FixedType, (A) -> B>) -> (Writer<FixedType, A>) -> Writer<FixedType, B> {
        return { m in
            fAB >>>= { f in m >>>= { x in Writer<FixedType, B>.pure( f(x) ) }}
        }
    }

   public func ap<B>(_ fAB: Writer<FixedType, (TypeParameter) -> B> ) -> Writer<FixedType, B> {
        return Writer<FixedType, B>.apLift(fAB)(self)
    }
}


extension WriterTag : ApplicativeTag {
	public static func pure<A>(_ a: A) -> Construct<WriterTag<FixedType>,A> {

// If you get an error on the next line like "Value of type "Writer<A> has no member pure"  that is
// because Writer conforms to the Applicative protocol but does not also implement this method:
// public static func pure<V>(_ v: V) -> Writer<V>
		return Writer<FixedType, A>.pure(a)^
	}

	public static func ap<A, B>(_ fAB: Construct<WriterTag<FixedType>,(A) -> B>) -> (Construct<WriterTag<FixedType>,A>) -> Construct<WriterTag<FixedType>,B> {
		return { fA in
			let fab = Writer<FixedType, (A) -> B>.lower(fAB)
			let wa = Writer<FixedType, A>.lower(fA)

			// If you get an error on the next line like "Value of type "Writer<A> has no member ap"  that is
			// because Writer conforms to the Applicative protocol but does not also implement this method:
			// public func ap<B>(_ fAB: Writer<(TypeParameter) -> B>) -> Writer<B>
			return wa.ap(fab)^
		}
	}
}

public func <*><FixedType,P,Q>(f: Writer<FixedType, (P) -> Q>, p: Writer<FixedType, P>) -> Construct<WriterTag<FixedType>,Q>
{
	return WriterTag.ap(f^)(p^)
}
public func <*><FixedType,P,Q>(f: Construct<WriterTag<FixedType>,(P) -> Q>, p: Writer<FixedType, P>) -> Construct<WriterTag<FixedType>,Q>
{
	return WriterTag.ap(f)(p^)
}

public func <¢><FixedType,P,Q>(f: @escaping (P) -> Q, p: Writer<FixedType, P>) -> Construct<WriterTag<FixedType>,Q>
{
	return WriterTag.ap(WriterTag.pure(f))(p^)
}

extension Appl2 {
	public subscript<FixedType>(_ first: Writer<FixedType, A>, _ second: Writer<FixedType, B> ) -> Writer<FixedType, C> {
		return appl( f: f2, to: first^, second^ )¬
	}
}
extension Appl3 {
	public subscript<FixedType>(_ first: Writer<FixedType, A>, _ second: Writer<FixedType, B>, _ third: Writer<FixedType, C> ) -> Writer<FixedType, D> {
		return appl( f: f3, to: first^, second^, third^ )¬
	}
}
extension Appl4 {
	public subscript<FixedType>(_ first: Writer<FixedType, A>, _ second: Writer<FixedType, B>, _ third: Writer<FixedType, C>, _ fourth: Writer<FixedType, D>  ) -> Writer<FixedType, E> {
		return appl( f: f4, to: first^, second^, third^, fourth^ )¬
	}
}
extension Appl5 {
	public subscript<FixedType>(_ first: Writer<FixedType, A>, _ second: Writer<FixedType, B>, _ third: Writer<FixedType, C>, _ fourth: Writer<FixedType, D>, _ fifth: Writer<FixedType, E>  ) -> Writer<FixedType, F> {
		return appl( f: f5, to: first^, second^, third^, fourth^, fifth^ )¬
	}
}
extension ApplReduce {
	public subscript<FixedType>(_ params: Writer<FixedType, Elt>...) -> Writer<FixedType, Elt> {
		return self.to(params.map(^))¬
	}
}




extension WriterTag : MonadTag {


	public static func bind<A,B>(_ m:Construct<WriterTag<FixedType>,A> ) -> ( @escaping (A) -> Construct<WriterTag<FixedType>,B>) -> Construct<WriterTag<FixedType>,B> {
		return { fA in
			let ml : Writer<FixedType, A> = Writer<FixedType, A>.lower(m)
			let wa : (A) -> Writer<FixedType, B> = { a in Writer<FixedType, B>.lower(fA(a)) }

			// If you get an error on the next line like "Value of type "Writer<A> has no member bind"  that is
			// because Writer conforms to the Monad protocol but does not also implement this method:
			// public func bind<B>(_ m: (TypeParameter) -> Writer<B>) -> Writer<B>
			return ml.bind(wa)^
		}
	}
}

extension Writer {
	public static func >>>=<B>( left: Writer<FixedType, TypeParameter>, right: @escaping (TypeParameter) -> Writer<FixedType, B>) -> Writer<FixedType, B> {
		return left.bind(right)
	}
}

public func >=> <FixedType,A,B,C>(l: @escaping (A) -> Writer<FixedType, B>, r: @escaping (B) -> Writer<FixedType, C> ) -> (A) -> Writer<FixedType, C> {
	return { a in l(a) >>>= r }
}
public func <=< <FixedType,A,B,C>(l: @escaping (B) -> Writer<FixedType, C>, r: @escaping (A) -> Writer<FixedType, B> ) -> (A) -> Writer<FixedType, C> {
return { a in r(a) >>>= l }
}

public func >=> <FixedType,A,B> (l: A, r: @escaping (A) -> Writer<FixedType, B> ) -> Writer<FixedType, B> {
	return Writer<FixedType, A>.pure(l) >>>= r
}

// mjoin implementation for free
extension Writer {
	public func mjoin<T>() -> Writer<FixedType, T> where TypeParameter == Writer<FixedType, T> {
		return self >>>= { $0 }
	}
}
// Sequence functions we get from a Monad for free
extension Sequence {
    public func mreduce<FixedType,TypeParameter,Result>(_ initialResult: Result, _ f: @escaping (Result, TypeParameter) -> Writer<FixedType, Result>) -> Writer<FixedType, Result> where Element == TypeParameter {
        if let s = self.first {
            return f(initialResult,s) >>>= { p in self.dropFirst().mreduce(p, f) }
        } else {
            return .pure(initialResult)
        }
    }

    public func mfilter<FixedType>(_ isIncluded: @escaping (Self.Element)  -> Writer<FixedType, Bool>)  -> Writer<FixedType, [Self.Element]> {
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
}






//MARK: - HKT for ZipArray  public

/// ZipArrayTag is the container type for values of ZipArray
public struct  ZipArrayTag : HKTTag  {
	public typealias ActualType = ZipArray
	fileprivate let _actual: Any
	public init<T>(_ actual:ZipArray<T>) { self._actual = actual as Any }
}

extension ZipArray : _TypeConstructor {
	public typealias Tag = ZipArrayTag
	public var lift: Construct<Tag, TypeParameter> {
		return Construct<Tag, TypeParameter>(tag: Tag(self))
	}

	public static func lower(_ con: Construct<Tag, TypeParameter>) -> ZipArray<TypeParameter> {
	return con.tag._actual as! ZipArray  
	}
}

extension Construct where ConstructorTag == ZipArrayTag
{
	public var lower: ZipArray<TypeParameter> { get {
		return ZipArray<TypeParameter>.lower(self)
	}}
public var toZipArray: ZipArray<TypeParameter> { get { return lower }}

}

public func >>>¬<A>(left: Construct<ZipArrayTag,A>, right: @escaping (Construct<ZipArrayTag,A>) -> ZipArray<A>) -> ZipArray<A>
{
	return right(left)
}

public postfix func¬<A>(left: Construct<ZipArrayTag,A>) -> ZipArray<A> {
	return ZipArray.lower(left)
}

public func toZipArray<A>(_ con:Construct<ZipArrayTag,A>) -> ZipArray<A> {
	return ZipArray<A>.lower(con)
}







extension ZipArrayTag : ApplicativeTag {
	public static func pure<A>(_ a: A) -> Construct<ZipArrayTag,A> {

// If you get an error on the next line like "Value of type "ZipArray<A> has no member pure"  that is
// because ZipArray conforms to the Applicative protocol but does not also implement this method:
// public static func pure<V>(_ v: V) -> ZipArray<V>
		return ZipArray<A>.pure(a)^
	}

	public static func ap<A, B>(_ fAB: Construct<ZipArrayTag,(A) -> B>) -> (Construct<ZipArrayTag,A>) -> Construct<ZipArrayTag,B> {
		return { fA in
			let fab = ZipArray<(A) -> B>.lower(fAB)
			let wa = ZipArray<A>.lower(fA)

			// If you get an error on the next line like "Value of type "ZipArray<A> has no member ap"  that is
			// because ZipArray conforms to the Applicative protocol but does not also implement this method:
			// public func ap<B>(_ fAB: ZipArray<(TypeParameter) -> B>) -> ZipArray<B>
			return wa.ap(fab)^
		}
	}
}

public func <*><P,Q>(f: ZipArray<(P) -> Q>, p: ZipArray<P>) -> Construct<ZipArrayTag,Q>
{
	return ZipArrayTag.ap(f^)(p^)
}
public func <*><P,Q>(f: Construct<ZipArrayTag,(P) -> Q>, p: ZipArray<P>) -> Construct<ZipArrayTag,Q>
{
	return ZipArrayTag.ap(f)(p^)
}

public func <¢><P,Q>(f: @escaping (P) -> Q, p: ZipArray<P>) -> Construct<ZipArrayTag,Q>
{
	return ZipArrayTag.ap(ZipArrayTag.pure(f))(p^)
}

extension Appl2 {
	public subscript(_ first: ZipArray<A>, _ second: ZipArray<B> ) -> ZipArray<C> {
		return appl( f: f2, to: first^, second^ )¬
	}
}
extension Appl3 {
	public subscript(_ first: ZipArray<A>, _ second: ZipArray<B>, _ third: ZipArray<C> ) -> ZipArray<D> {
		return appl( f: f3, to: first^, second^, third^ )¬
	}
}
extension Appl4 {
	public subscript(_ first: ZipArray<A>, _ second: ZipArray<B>, _ third: ZipArray<C>, _ fourth: ZipArray<D>  ) -> ZipArray<E> {
		return appl( f: f4, to: first^, second^, third^, fourth^ )¬
	}
}
extension Appl5 {
	public subscript(_ first: ZipArray<A>, _ second: ZipArray<B>, _ third: ZipArray<C>, _ fourth: ZipArray<D>, _ fifth: ZipArray<E>  ) -> ZipArray<F> {
		return appl( f: f5, to: first^, second^, third^, fourth^, fifth^ )¬
	}
}
extension ApplReduce {
	public subscript(_ params: ZipArray<Elt>...) -> ZipArray<Elt> {
		return self.to(params.map(^))¬
	}
}


// Auto-generating Functor instance from Applicative
extension ZipArray : Functor   {
	public func fmap<B>(_ transform: @escaping (TypeParameter) -> B) -> ZipArray<B> {
		return self.ap(ZipArray.pure(transform))
	}
}

extension ZipArrayTag : FunctorTag {
	public static func fmap<TypeParameter, B>(_ transform: @escaping (TypeParameter) -> B) -> (Construct<ZipArrayTag,TypeParameter>) -> Construct<ZipArrayTag,B> {
		return { applyA in
			let a = ZipArray<TypeParameter>.lower(applyA)
			return a.fmap(transform)^
		}
	}
}





