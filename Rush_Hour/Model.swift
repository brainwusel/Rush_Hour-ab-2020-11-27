//
//  Model.swift
//  Rush_Hour
//
//  Created by UT on 20.11.20.
//

import Foundation
import Cocoa

// 6 x 6
// von LINKS nach RECHTS waagerecht w =  1 2 3 4 5 6
// von UNTEN nach OBEN nach senkrecht s = 1 2 3 4 5 6
// Ausgang rechts neben w = 6 / s = 4
// CAVE im zweidimensionalen Array SPIEL.GRID, welches die einzelnen Zellen das 6 x 6 Spielfeldes repräsentiert, sind die Indizes der einzelnen Felder um den Wert 1 KLEINER (0 ... 5, da Array) als die Positionsbezeichnung in der KLasse CAR (w bzw. s 1...6)

// Länge des Autos
enum Länge {
    case zwei
    case drei
}

// Orientierung des Autos auf dem Spielfeld
enum Orientierung {
    case waagerecht
    case senkrecht
    case unbestimmt
}

// Bewegungsrichtung: Optionen für Autos bzw. Input über Maus / Taste
enum Richtung {
    case rechts
    case links
    case rauf
    case runter
    case unbeweglich
}

enum Inhalt {
    case leer
    case voll
}

struct Bild: Hashable, Equatable {
    var name: String
    var orientierung: Orientierung
    var länge: Länge
    init (Name: String, Orientierung: Orientierung, Länge: Länge) {
        self.name = Name
        self.orientierung = Orientierung
        self.länge = Länge
    }
}

var bildContainer: Array <Bild> {
    var s = Array <Bild>()
    s.append(Bild(Name: "w20", Orientierung: .waagerecht, Länge: .zwei))
    s.append(Bild(Name: "w21", Orientierung: .waagerecht, Länge: .zwei))
    s.append(Bild(Name: "w22", Orientierung: .waagerecht, Länge: .zwei))
    s.append(Bild(Name: "w23", Orientierung: .waagerecht, Länge: .zwei))
    s.append(Bild(Name: "w30", Orientierung: .waagerecht, Länge: .drei))
    s.append(Bild(Name: "w31", Orientierung: .waagerecht, Länge: .drei))
    s.append(Bild(Name: "w32", Orientierung: .waagerecht, Länge: .drei))
    s.append(Bild(Name: "w33", Orientierung: .waagerecht, Länge: .drei))
    s.append(Bild(Name: "s20", Orientierung: .senkrecht, Länge: .zwei))
    s.append(Bild(Name: "s21", Orientierung: .senkrecht, Länge: .zwei))
    s.append(Bild(Name: "s22", Orientierung: .senkrecht, Länge: .zwei))
    s.append(Bild(Name: "s23", Orientierung: .senkrecht, Länge: .zwei))
    s.append(Bild(Name: "s30", Orientierung: .senkrecht, Länge: .drei))
    s.append(Bild(Name: "s31", Orientierung: .senkrecht, Länge: .drei))
    s.append(Bild(Name: "s32", Orientierung: .senkrecht, Länge: .drei))
    s.append(Bild(Name: "s33", Orientierung: .senkrecht, Länge: .drei))
    return s
}

// einzelnes Auto - identifiziert durch Länge und Farbe in der computet prop. ID als String. Aus der Aufgabenstellung ergeben sich die Eigenschaften POSITIONLINKSOBEN und ORIENTIERUNG. Die Eigenschaft BEWEGUNGSOPTIONEN zeigt als Array von Richtungen an, wohin ein Auto bewegt werden könnte; sie wird zunächst mit einem Element .UNBEWEGLICH initialisiert und später durch die Methode SPIEL.BEWEGUNGSOPTIONENUPDATE aus den Positionsdaten aller Autos berechnet. Die Eigenschaft ZELLENBELEGT zeigt an, welche Zellen gerade von einem Auto im Grid belegt werden und wird berechnet aus der POSITIONLINKSOBEN, der LÄNGE und der ORIENTIERUNG des Autos; in der get-Funktion sind KEINE Überprüfungen der waagerechten oder senkrechten Limits enthalten - diese Aufgabe sollte vollständig von der Methode SPIEL.BEWEGUNSOPTIONENUPDATE übernommen werden

class Car {
    var länge: Länge
    var orientierung: Orientierung
    var positionLinksUnten: (w: Int, s: Int)
    var bewegungsOptionen: [Richtung]
    var rechtEck = NSRect()
    var image: NSImage?
    var id: String
    
    init (länge: Länge, positionLinksUnten: (w: Int, s: Int), richtung: Orientierung) {
        self.länge = länge
        self.orientierung = richtung
        self.positionLinksUnten = positionLinksUnten
        self.bewegungsOptionen = [.unbeweglich]
        self.id = ("\(länge)\(richtung)\(positionLinksUnten.w)\(positionLinksUnten.s)")
    }
    
    var zellenBelegt: [(w: Int, s: Int)] {
        get {
            var zB = [(w: Int, s: Int)]()
            zB.append((w: min(6, max(1, positionLinksUnten.w)), s: min(6, max(1, positionLinksUnten.s))))
            
            if länge == .zwei && orientierung == .waagerecht
            {
                zB.append((w: min(positionLinksUnten.w + 1, 6),
                           s: positionLinksUnten.s))
            }
            if länge == .zwei && orientierung == .senkrecht
            {
                zB.append((w: positionLinksUnten.w,
                           s: min(positionLinksUnten.s + 1, 6)))
            }
            if länge == .drei && orientierung == .waagerecht
            {
                zB.append((w: min(positionLinksUnten.w + 1, 6),
                           s: positionLinksUnten.s))
                zB.append((w: min(positionLinksUnten.w + 2, 6),
                           s: positionLinksUnten.s))
            }
            if länge == .drei && orientierung == .senkrecht
            {
                zB.append((w: positionLinksUnten.w,
                           s: min(positionLinksUnten.s + 1, 6)))
                zB.append((w: positionLinksUnten.w,
                           s: min(positionLinksUnten.s + 2, 6)))
            }
            return zB
        }
    }
}

//  Aufgabe 1 aus ScreenShot - "Zweier" rot ist das Exit-Auto

func aufgabeLaden (nummer: Int) -> [Car]
{
    var autos = [Car]()
    var aufgabenAlleString = String()
    var aufgabeString = String()
    let p = Bundle.main.path(forResource: "aufgaben", ofType: "csv")
    aufgabenAlleString = try! String(contentsOfFile: p!, encoding: .utf8)
    let aufgabenAlleStringArray = aufgabenAlleString.components(separatedBy: "#")
    aufgabeString = aufgabenAlleStringArray[nummer]
    var carStrings = aufgabeString.components(separatedBy: "\r\n")
    
    while carStrings.last == ""
    {
        carStrings.removeLast()
    }
    
    for i in 1 ... carStrings.count - 1
    {
        let carComponents = carStrings[i].components(separatedBy: ";")
        let l: Länge
        switch carComponents[0]
        {
        case "2":
            l = .zwei
        case "3":
            l = .drei
        default:
            l = .zwei
        }
        let w = Int(carComponents[1])
        let s = Int(carComponents[2])
        var o: Orientierung
        switch carComponents[3]
        {
        case "w":
            o = .waagerecht
        case "s":
            o = .senkrecht
        default:
            o = .waagerecht
        }
        let auto = Car(länge: l, positionLinksUnten: (w: w!, s: s!), richtung: o)
        autos.append(auto)
    }
    return autos
}


class Spiel {
    
    var cars: [Car] 
    var gewonnen: Bool
    var aufgabeNummer: Int
    
    init (Aufgabe nr: Int) {
        self.gewonnen = false
        self.aufgabeNummer = nr
        self.cars = aufgabeLaden(nummer: aufgabeNummer)
        bilderZuordnen()
    }
    
    var grid: [[String]] {
        get
        {   var g = [[String]](repeating: [String](repeating: " ", count: 6), count: 6) // 6 x 6 - alle Felder mit " " belegen
            gewonnen = false
            for auto in cars {
                for pos in auto.zellenBelegt {
                    g[pos.w - 1][pos.s - 1] = auto.id
                    if auto.zellenBelegt.first! == (w: 6, s: 4) &&
                        auto.orientierung == .waagerecht &&
                        auto.länge == .zwei
                    {
                        gewonnen = true
                    }
                }
            }
            return g
        }
    }
    
    func bilderZuordnen ()
    {
        var bc = bildContainer
        
        for c in 0...cars.count - 1
        {
            if cars[c].positionLinksUnten.s == 4 && cars[c].orientierung == .waagerecht
            {
                for b in 0 ... bc.count - 1
                {
                    if bc[b].name == "w20"
                    {
                        cars[c].image = NSImage(imageLiteralResourceName: "w20")
                        bc[b].orientierung = .unbestimmt
                        break
                    }
                }
            }
            else
            {
                for b in 0 ... bc.count - 1
                {
                    if bc[b].name != "w20"
                    {
                        if cars[c].länge == bc[b].länge && cars[c].orientierung == bc[b].orientierung
                        {
                            cars[c].image = NSImage(imageLiteralResourceName: bc[b].name)
                            bc[b].orientierung = .unbestimmt
                            break
                        }
                    }
                }
            }
        }
    }
    
    
    func move (autoID: String, wohin: Richtung) {
        for i in 0 ... cars.count - 1 {
            if cars[i].id == autoID {
                if cars[i].bewegungsOptionen.contains(wohin) {
                    switch wohin {
                    case .rechts:
                        cars[i].positionLinksUnten.w = min(cars[i].positionLinksUnten.w + 1, 6)
                    case .links:
                        cars[i].positionLinksUnten.w = max(cars[i].positionLinksUnten.w - 1, 1)
                    case .rauf:
                        cars[i].positionLinksUnten.s = min(cars[i].positionLinksUnten.s + 1, 6)
                    case .runter:
                        cars[i].positionLinksUnten.s = max(cars[i].positionLinksUnten.s - 1, 1)
                    default:
                        return
                    }
                }
            }
        }
        bewegungsOptionenUpdate()
    }
    
    func bewegungsOptionenUpdate () {
        for i in 0...cars.count - 1 {
            cars[i].bewegungsOptionen.removeAll()
            
            let links = cars[i].zellenBelegt.first?.w
            let rechts = cars[i].zellenBelegt.last?.w
            let unten = cars[i].zellenBelegt.first?.s
            let oben = cars[i].zellenBelegt.last?.s
            
            if cars[i].orientierung == .waagerecht
            {
                if links! > 1 && grid[links! - 2][unten! - 1] == " "
                {
                    cars[i].bewegungsOptionen.append(.links)
                }
                if rechts! < 6 && grid[rechts!][oben! - 1] == " "
                {
                    cars[i].bewegungsOptionen.append(.rechts)
                }
                if rechts! == 6 && oben! == 4
                {                    // Exit!
                    cars[i].bewegungsOptionen.append(.rechts)
                }
            }
            
            if cars[i].orientierung == .senkrecht
            {
                if unten! > 1 && grid[links! - 1][unten! - 2] == " "
                {
                    cars[i].bewegungsOptionen.append(.runter)
                }
                if oben! < 6 && grid[rechts! - 1][oben!] == " "
                {
                    cars[i].bewegungsOptionen.append(.rauf)
                }
            }
        }
    }
    
    func zurückAufAnfang () {
        self.gewonnen = false
        self.cars = aufgabeLaden(nummer: aufgabeNummer)
        bilderZuordnen()
    }
}



