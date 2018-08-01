//
//  helpers.swift
//  FunctorProject
//
//  Created by @strictlyswift on 7/5/18.
//

import Foundation
import HKTFramework

extension String {
    public func matchesRE(_ regex: String, options: NSRegularExpression.Options = [] ) -> Bool? {
        guard let re = try? NSRegularExpression(pattern: regex, options: options) else { return nil }
        return (re.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count ))?.range(at: 0).length ?? 0) > 0
    }
}

public let lettersOnlyValidator : (String) -> Bool = { return ($0.rangeOfCharacter(from: CharacterSet.letters.inverted )) == nil }
public let emailValidator : (String) -> Bool = { return ($0.matchesRE("[a-zA-Z0-9]+@[a-zA-Z0-9]+\\.[a-zA-Z0-9]+") ?? false) }

public func findUserName(_ withEmail:String) ->  WebData<String> {
    switch withEmail {
    case "bjones@email.com":
        return .safe("Bob Jones")
    default:
        return .taint("unknown")
    }
}


public let cities = ["Newcastle", "Manchester", "Liverpool"]
public let teamAForCity = [ "Newcastle" : ["Sarah","George","Xu"], "Manchester" : ["Carlos","Alex","Claire"], "Liverpool" : ["Brad","Sujith"]]
public let teamBForCity = [ "Newcastle" : ["Peter","Petra"], "Manchester" : ["Carla","Craig"], "Liverpool" : ["Richard","Rachel","Raquel"]]

public struct Matchup { let city, player1, player2 : String; public init(city:String, player1: String, player2: String) { self.player1 = player1; self.player2 = player2; self.city = city } }

public enum Team {
    case A
    case B
    func sideFor(_ city: String) -> [String] {
        switch self {
        case .A: return teamAForCity[city] ?? []
        case .B: return teamBForCity[city] ?? []
        }
    }
}

public func teamForCity(_ city:String, _ team: Team) -> [String] {
    return team.sideFor(city)
}

////////////////
public struct Pict {
    let pixels: [UInt8]
    public init(pixels:[UInt8]) {
        self.pixels = pixels
    }
    
    func display() -> String { return "Pict:\(pixels)" }
}

extension Pict {
    public func displayWithLog(log: [String] ) -> (String,[String]) {
        return (self.display(), log + ["Displaying picture"])
    }
    
    public func resizePicture(byScale: Double, log: [String] ) -> (Pict,[String])  {
        return (self, log + ["Resize by factor of \(byScale)"])
    }
    
    public func rotatePicture(byAngle: Double, log: [String] ) -> (Pict,[String]) {
        return (self,  log + ["Rotate picture by angle of \(byAngle)"] )
    }
}

public protocol PictureOperation {
    var name: String { get }
    func operation(p: Pict) -> Pict
}

public struct RotateOperation : PictureOperation {
    let angle : Double
    public init(angle:Double) { self.angle = angle }
    public var name : String { get { return "Rotate by angle \(angle)" }}
    public func operation(p: Pict) -> Pict { return p }
}
public struct ResizeOperation : PictureOperation {
    let scale : Double
    public init(scale:Double) { self.scale = scale }
    public var name : String { get { return "Resize picture by factor of \(scale)" }}
    public func operation(p: Pict) -> Pict { return p }
}

///////////
public let pageSize = CGSize(width: 400, height: 400)

public enum OutputContext {
    
    case screen(size: CGSize, colour: Bool)
    case printout(size: CGSize)
    case asciiArt


    public func mapTone(d: CGFloat, picture: Pict) -> Pict {
        //...
        return picture
    }
    public func scaleToFit(picture: Pict) -> Pict {
        //...
        return picture
    }
    public func render(picture:Pict) -> Void {
        switch self {
        case .screen(size: _, colour: let col): print("Showing on screen in \(col ? "colour" : "b/w")")
        case .printout(size: _): print("Printing")
        case .asciiArt: print("ASCII Art!")
        }
        return
    }
}
extension Pict {
    public static func toneMapping(d: CGFloat) -> (Pict) -> Reader<OutputContext, Pict> {
        return { picture in
            return Reader  { context in
                context.mapTone(d: d, picture: picture)
            }
        }
    }
    public static func scaleToFit(picture: Pict) -> Reader<OutputContext, Pict> {
        return Reader { context in
            context.scaleToFit(picture: picture)
        }
    }
    public static func performRender(picture: Pict) -> Reader<OutputContext, Void> {
        return Reader { context in
            context.render(picture: picture)
        }
    }
    
    public func scaleToFit() -> Reader<OutputContext, Pict> {
        return Reader { context in
            context.scaleToFit(picture: self)
        }
    }
    public func performRender() -> Reader<OutputContext, Void> {
        return Reader { context in
            context.render(picture: self)
        }
    }
    
}
