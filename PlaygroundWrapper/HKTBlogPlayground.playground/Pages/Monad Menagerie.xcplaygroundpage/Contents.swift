import Foundation
import HKTBlogFramework
import HKTFramework
/*:
 ## HKT Playground

 # 3. Monad Menagerie
 [Previous Page: Monad Magic](@previous)
 
 See [article.](https://medium.com/@JLHLonline/a-monad-menagerie-15e5b96d9ca7)
 
 ## Writers
 */
/*:
Writers represent a value, and an 'accumulation' : eg a running total, or a log.

Suppose we have a graphics package to manipulate Pictures
 
    struct Pict {  let pixels: [UInt8]  ... }
 
*/
//: We want to log every manipulation. Eg, converting a picture to grey-scale:
extension Pict {
    func makeGreyScale(log:  [String] ) -> (Pict,[String]) {
        return (self /* .map { ... } */, log + ["Convert to grey scale"])
    }
}

//: ... but now, repeated manipulations get difficult to manage because of that 'log' :
let initialPicture = Pict(pixels:Array<UInt8>(repeating:100, count:10))
let greyScaleVersion = initialPicture.makeGreyScale(log: [])
let resizedVersion = greyScaleVersion.0.resizePicture(byScale: 0.5, log: greyScaleVersion.1)
let rotatedVersion = resizedVersion.0.rotatePicture(byAngle: 90, log: resizedVersion.1)
let displayedVersion = rotatedVersion.0.displayWithLog(log: rotatedVersion.1)
displayedVersion.1
displayedVersion.0

/*:
  We can do better by writing each picture operation as a type, instead of a function.

  First let's define a protocol which manages both the name for logging, as well as the operation:

          protocol PictureOperation {
              var name: String { get }
              func operation(p: Pict) -> Pict
          }

  Then for example:
 */
struct GreyScaleOperation : PictureOperation {
    let name = "Convert to grey scale"
    func operation(p: Pict) -> Pict { return p  /* ... with more manipulation... */ }
}
/*:
   Now, we use the Writer monad to keep track of the log for us.
   We need a little helper function (written in curried style, for reasons which will become apparent):
 */
func adjustPicture(do op: PictureOperation) -> (Pict) -> Writer<[String], Pict> {
    return { picture in
        return Writer(writing: [op.name], value: op.operation(p:picture))
    }
}
//: Then, we can use 'bind' over the Writer to both adjust the picture and keep track of the log:
let adjusted : Writer<[String], Pict> =
    adjustPicture( do: GreyScaleOperation() )( initialPicture ) >>>= { p1 in
        adjustPicture( do: RotateOperation(angle: 90) )(p1) >>>= { p2 in
            adjustPicture( do: ResizeOperation(scale: 0.5) )(p2)
        }}

//: _(Note, when we look at Kleiski categories and the >=> operator, we'll see a neater way to do this)_

//: The Writer tracks the final value, and accumulates the log:
let adjustedPicture = adjusted.value
let logOutput = adjusted.writing


/*:
 ## READERS
 Readers represent function application. (They are nothing to do with Writers)
 You can think of them also as 'returning a value in a context', where the 'context'
 might be a dependency (eg an environment, like "Production" or "Development")

 For instance, let's say we have an 'OutputContext' for our Pictures, describing how we might display them:
 
         enum OutputContext {
             case screen(size: CGSize, colour: Bool)
             case printout(size: CGSize)
             case asciiArt
         }

 Prior to display, we might want to do some manipulations which are dependent on exactly what
 the output context is.  For example, we change the tonal mapping for printouts in order to better
 represent the colours we see when printing to paper, vs the screen.
 */
extension Pict {
    func toneMapping(_ d: CGFloat) -> Reader<OutputContext, Pict> {
        return Reader { context in
            context.mapTone(d: d, picture: self)
        }
    }
}

//: We use `>>>=` to glue these functions together, for output in a particular context:
extension Pict {
    func renderToContext() -> Reader<OutputContext, Void> {
        return  .pure(self) >>>= { p1 in
            p1.toneMapping(0.5) >>>= { p2 in
                p2.scaleToFit() >>>= { p3 in
                    p3.performRender()
                }}}
    }
}


//: Now, when we actually want to output the picture, we can apply the context via the 'apply' function on Reader:
adjustedPicture.renderToContext().apply(.asciiArt)  // prints "ASCII Art!"  on the console
adjustedPicture.renderToContext().apply(.printout(size: pageSize))  // prints "Printing" on the console


/*:
 ## Futures

 _(Thanks to John Sundell)_

 Let's suppose we have User data we want to retrieve from a URLSession.
 We have to first make an external call to get the internal ID for a username;
 and then make a second call to get the detailed data from that ID.
 Finally, we convert the data into a User object.
*/
struct User { let fromData: Data }
struct LoaderSession { let urlSession: URLSession, url: URL }

//: We also have a couple of functions which extend a root URL to pull out additional info:
extension LoaderSession {
    func urlForIdLookup(_ id: String) -> URL {
        return self.url.appendingPathComponent("/\(id)")
    }
    func urlForDetailLookupFrom(data: Data) -> URL {
        return self.url.appendingPathComponent("/\(data[0...4])")
    }
}

/*:
 Now we can write a single function which carries out all of the calls needed to get the
 data from the external endpoint.  We want to return a Future, so that the call can
 return only when the far endpoint responds:
*/
func userLoader( id: String, session: LoaderSession ) -> Future<User> {
    return
        session.urlSession.requestData(url: session.urlForIdLookup(id)) >>>= { data in
            session.urlSession.requestData(url: session.urlForDetailLookupFrom(data: data)) } >>>• { dt in
                User(fromData: dt) }
}
/*:
 Note the `>>>•`   (`•` is ALT+8) ... that's the operator version of fmap.
 `session.urlSession.requestData` will return a Future<Data>(check the Future.swift file)
 but after we have retrieved the detailed data, we want to convert it into a User by mapping
 the data to User.  We can do that with fmap which _also_ preserves the Future:
 so it will return a Promise if the external calls work properly.
 */


