import Foundation
import HKTBlogFramework
import HKTFramework
/*:
 ## HKT Playground
# 2. Monad Magic
 [Previous Page: Applicatives](@previous)
 
 [Next Page: Monad Menagerie](@next)
 
 See [article.](https://medium.com/@JLHLonline/monad-magic-d355a761e294)
## WebData Again
*/
//: Let's say we get some input from the web
let emailInput = WebData("bjones@email.com", withValidator: emailValidator)
let dodgyEmailInput = WebData("fak3N@m3", withValidator: emailValidator)

//: and we want to greet the user...
let greeter: (String) -> WebData<String> = { return WebData.safe("Hi \($0)!") }

//: We need to be careful when we greet someone though - "greeter" turns every input into a 'safe' input.
//: Let's keep it tainted if it was tainted initially:
func greetSafely(_ name: WebData<String> ) -> WebData<String> {
    switch name {
    case .safe(let n): return greeter(n)
    case .taint(let n): return greeter(n).taint()
    }
}

greetSafely( emailInput )
greetSafely( dodgyEmailInput )

//: How about a more generic version that's not tied to greeter? That would look like this:
extension WebData {
    func applySafely<B>(_ trans: @escaping (A) -> WebData<B> ) -> WebData<B> {
        switch self {
        case .taint(let a): return trans(a).taint()
        case .safe(let a): return trans(a)
        }
    }
}

/*:
   So if we have a way of finding the name of a user from their email:

       func findUserName(_ withEmail:String) ->  WebData<String>
*/
//: Let's try that:
emailInput.applySafely(findUserName).applySafely(greeter)
dodgyEmailInput.applySafely(findUserName).applySafely(greeter)


//: WebData also defines an operator >>>= called "bind"
//: which basically just calls "applySafely" on its right-hand argument.
//: Now we can chain these nicely!
emailInput >>>= findUserName >>>= greeter
dodgyEmailInput >>>= findUserName >>>= greeter

/*:
   * Therefore WebData is a Monad... it defines "bind" , and also "pure" (see the `WebData.swift` file)
   * Optional is a Monad too, and we define "bind" and "pure" for it (see `ArrayOptionalFunctor.swift`)
*/

//: Suppose we have a list of Strings, possibly representing numbers, and we want to check if the first value in the list is even.
//: If the list is empty, or if the first value is not an even number, then return nil.

let list : [String] = ["2", "1", "2.5", "2"]

//: A couple of helper functions:
let firstValue : ([String]) -> String? = { $0.first }
let toInt : (String) -> Int? = { Int($0) }
let isEven : (Int) -> String? = { ($0 % 2 == 0) ? "even" : nil }

//: Thanks to the Monad bindings, calculating the result is now very straightforward, with no optional unwrapping!
let firstValueIsEven = list >>>= firstValue >>>= toInt >>>= isEven

//: How would we do that WITHOUT the monad binding?  It gets pretty ugly !
var firstValueIsEven2 : String? = nil
if let first = firstValue(list), let asInt = toInt(first) {
    firstValueIsEven2 = isEven(asInt)
}

/*:
 ## Arrays as Monads
 Arrays are monads too... "bind" is EXACTLY flatMap. In fact you could say monads are "flattenable" (flatmappable)

   Suppose we are running a chess tournament in 3 different cities. We want to produce the roster of all the different games, where every competitor must play everyone else.
*/
//: Let's try this using regular array functions:
func matchupsForCities(cities:[String]) -> [Matchup] {
    var matchups = [Matchup]()
    for city in cities {
        let teamA = teamForCity(city, Team.A)
        let teamB = teamForCity(city, Team.B)
        for p1 in teamA {
            for p2 in teamB {
                matchups += [Matchup(city:city,
                                     player1:p1,
                                     player2:p2)]
            }
        }
    }
    return matchups
}

//: Using bind  (remember -- it's really flatMap!) makes this much easier to read:
func matchupsForCities2(cities:[String]) -> [Matchup] {
    return cities >>>= { city in
        teamForCity(city, Team.A) >>>= { p1 in
            teamForCity(city, Team.B) >>>= { p2 in
                [Matchup(city:city, player1:p1, player2:p2)]
            }}}
}

matchupsForCities(cities: cities)
