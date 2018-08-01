import Foundation
import HKTBlogFramework
import HKTFramework
/*:
 ## HKT Playground
   # 1. Applicatives
 [Next Page: Monad Magic](@next)
   ## WebData
*/
//: Calculate retirement fund. Note, no WebData here.
func calcAnnualRetirementFund( ageNow: Int,
                               ageRetire: Int,
                               savings: Double ) -> Double {
    return savings/Double(ageRetire-ageNow)
}

//: Suppose we get data from the Web.
//: It's tainted by default:
let ageFromWeb = WebData.taint(40)
let retirementAge = WebData.taint(65)
let savingsToRetire = WebData.taint(100000.00)

//: Appl3 applies a 3-parameter function
//: across 3 items in  [ ... ]
let result = Appl3(calcAnnualRetirementFund)[ ageFromWeb, retirementAge, savingsToRetire ]


//: Now, let's clean the data:
let cleanedAge = ageFromWeb.clean()
let cleanedRetirementAge = retirementAge.clean()
let cleanedSavings = savingsToRetire.clean()

let result2 = Appl3(calcAnnualRetirementFund)[ cleanedAge, cleanedRetirementAge, cleanedSavings ]

//: Continuation-passing style
let result3 = curry(calcAnnualRetirementFund)
    <¢> cleanedAge^
    <*> cleanedRetirementAge^
    <*> cleanedSavings^
    >>>¬ toWebData

//: We can use ApplReduce to apply a function like + to a list of parameters
ApplReduce(+)[ WebData.taint(1), WebData.taint(2), WebData.taint(3), WebData.taint(4)]



/*:
   ---
 ###  EXPERIMENT!
  * What happens if some of the inputs are clean, and some are tainted, for Appl3 and ApplReduce?
  * Define a 2-parameter function. Use Appl2 to call it. Does it do what you expect with clean and tainted inputs?
  * Given that Applicative for WebData defines pure and ap as:
 
          static func pure<V>(_ v: V) -> WebData<V>
          func ap<B>(_ fab: WebData<(A) -> B>) -> WebData<B>
 
     ... define `fmap<B>(_ transform: (A) -> B) -> WebData<B>`
 
   ---
*/

/*:
   ## Other Applicatives

Optional as an applicative functor
*/
let val1 = Int("123")
let val2 = Int("3;45")
let val3 = Int("456")

//: Any function with a nil will fail to nil
ApplReduce(+)[val1, val2, val3]
ApplReduce(+)[val1, 345, val3]   // Replace the nil

//: How would we write that without using Optional as an applicative functor?
//:   * print( val1 + val2 + val3 )   won't work as + is not applicable to Optional
let combine: Int?
if let v1 = val1, let v2 = val2, let v3 = val3 { combine = v1+v2+v3 } else { combine = nil }  // << we have to pull apart the optional



//: Array is interesting, the default applicative functor treats Array as a 'choice'
//: function (imagine Array as returning potential multiple values from a function).
//: So any functions on array look at all of the possible choices.

Appl3(calcAnnualRetirementFund)[ [23,40], [55,60], [120_000.0, 1_000_000] ]

ApplReduce(+)[ ["hi","yo"], [" "], ["you","me"], ["!","?","."] ]

//: But that might not be what we want; so we can use ZipArray to 'zip' the arguments
//: together before applying the function. Note that this assumes the arrays are all
//: the same size
Appl3(calcAnnualRetirementFund)[ ZipArray(23,40), ZipArray(55,60), ZipArray(120_000.0, 1_000_000) ]

//: ApplReduce ignores the 'extra' third entry in the last array.
ApplReduce(+)[ ZipArray("hi","yo"), ZipArray(",","."), ZipArray("you","me"), ZipArray("!","?",".") ]

//: Here's another WebData example
let firstNameFromWeb = WebData("Bob")
let lastNameFromWeb = WebData("Jones")

ApplReduce(+)[firstNameFromWeb, WebData(" "), lastNameFromWeb]
ApplReduce(+)[WebData(1), WebData(2), WebData(3)]


/*:
  ### Experiment!
 
  1. Define LinkedList as an Applicative Functor.
  2. Look at the definition of WebData.pure and ZipData.pure.  They are quite unusual. Why are they defined like this?  Try changing the definition and see what happens.
  3. Define one of your own types as an Applicative Functor.
*/

