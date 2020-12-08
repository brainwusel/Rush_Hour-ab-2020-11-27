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

var bildContainer: [String: (Orientierung: Orientierung, Länge: Länge, Inhalt: Inhalt)] =
    [
        "w20": (.waagerecht, .zwei, .voll),
        "w21": (.waagerecht, .zwei, .leer),
        "w22": (.waagerecht, .zwei, .leer),
        "w23": (.waagerecht, .zwei, .leer),
        "w30": (.waagerecht, .drei, .leer),
        "w31": (.waagerecht, .drei, .leer),
        "w32": (.waagerecht, .drei, .leer),
        "w33": (.waagerecht, .drei, .leer),
        "s20": (.senkrecht, .zwei, .voll),
        "s21": (.senkrecht, .zwei, .leer),
        "s22": (.senkrecht, .zwei, .leer),
        "s23": (.senkrecht, .zwei, .leer),
        "s30": (.senkrecht, .drei, .voll),
        "s31": (.senkrecht, .drei, .voll),
        "s32": (.senkrecht, .drei, .leer),
        "s33": (.senkrecht, .drei, .leer),
    ]

// einzelnes Auto - identifiziert durch Länge und Farbe in der computet prop. ID als String. Aus der Aufgabenstellung ergeben sich die Eigenschaften POSITIONLINKSOBEN und ORIENTIERUNG. Die Eigenschaft BEWEGUNGSOPTIONEN zeigt als Array von Richtungen an, wohin ein Auto bewegt werden könnte; sie wird zunächst mit einem Element .UNBEWEGLICH initialisiert und später durch die Methode SPIEL.BEWEGUNGSOPTIONENUPDATE aus den Positionsdaten aller Autos berechnet. Die Eigenschaft ZELLENBELEGT zeigt an, welche Zellen gerade von einem Auto im Grid belegt werden und wird berechnet aus der POSITIONLINKSOBEN, der LÄNGE und der ORIENTIERUNG des Autos; in der get-Funktion sind KEINE Überprüfungen der waagerechten oder senkrechten Limits enthalten - diese Aufgabe sollte vollständig von der Methode SPIEL.BEWEGUNSOPTIONENUPDATE übernommen werden

class Car {
    var länge: Länge
    var füllFarbe: NSColor
    var randFarbe: NSColor
    var orientierung: Orientierung
    var positionLinksUnten: (w: Int, s: Int)
    var bewegungsOptionen: [Richtung]
    var rechtEck = NSRect()
    var image: NSImage?
    
    init (länge: Länge, füllFarbe: NSColor, randFarbe: NSColor, positionLinksUnten: (w: Int, s: Int), richtung: Orientierung) {
        self.länge = länge
        self.füllFarbe = füllFarbe
        self.randFarbe = randFarbe
        self.orientierung = richtung
        self.positionLinksUnten = positionLinksUnten
        self.bewegungsOptionen = [.unbeweglich]
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
    
    var id: String {
        get {
            return ("\(self.länge)/\(self.füllFarbe)")
        }
    }
}

//  Aufgabe 0 aus ScreenShot - "Zweier" rot ist das Exit-Auto

func aufgabeLaden (nummer: Int) -> [Car] {
    var autos = [Car]()
    
    switch nummer {
    
    case 0:
        autos.append(Car(länge: .zwei, füllFarbe: .red, randFarbe: .black, positionLinksUnten: (w: 2, s: 4), richtung: .waagerecht))    // Index 0 = Exit-Auto
        autos.append(Car(länge: .zwei, füllFarbe: .yellow, randFarbe: .black, positionLinksUnten: (w: 1, s: 6), richtung: .waagerecht)) // Index 1
        autos.append(Car(länge: .zwei, füllFarbe: .green, randFarbe: .black, positionLinksUnten: (w: 5, s: 2), richtung: .waagerecht))  // Index 2
        autos.append(Car(länge: .zwei, füllFarbe: .blue, randFarbe: .black, positionLinksUnten: (w: 1, s: 1), richtung: .senkrecht))    // Index 3
        
        autos.append(Car(länge: .drei, füllFarbe: .orange, randFarbe: .black, positionLinksUnten: (w: 1, s: 3), richtung: .senkrecht))     // Index 4
        autos.append(Car(länge: .drei, füllFarbe: .systemYellow, randFarbe: .black, positionLinksUnten: (w: 6, s: 4), richtung: .senkrecht))  // Index 5
        autos.append(Car(länge: .drei, füllFarbe: .systemGreen, randFarbe: .black, positionLinksUnten: (w: 3, s: 1), richtung: .waagerecht))  // Index 6
        autos.append(Car(länge: .drei, füllFarbe: .systemBlue, randFarbe: .black, positionLinksUnten: (w: 4, s: 3), richtung: .senkrecht))    // Index 7
    case 1:
        autos.append(Car(länge: .zwei, füllFarbe: .red, randFarbe: .black, positionLinksUnten: (w: 1, s: 4), richtung: .waagerecht))    // Index 0 = Exit-Auto
        autos.append(Car(länge: .zwei, füllFarbe: .yellow, randFarbe: .black, positionLinksUnten: (w: 4, s: 5), richtung: .senkrecht)) // Index 1
        autos.append(Car(länge: .zwei, füllFarbe: .green, randFarbe: .black, positionLinksUnten: (w: 4, s: 3), richtung: .senkrecht))  // Index 2
        autos.append(Car(länge: .zwei, füllFarbe: .blue, randFarbe: .black, positionLinksUnten: (w: 4, s: 2), richtung: .waagerecht))    // Index 3
        
        autos.append(Car(länge: .zwei, füllFarbe: .orange, randFarbe: .black, positionLinksUnten: (w: 6, s: 1), richtung: .senkrecht))     // Index 4
        autos.append(Car(länge: .zwei, füllFarbe: .systemYellow, randFarbe: .black, positionLinksUnten: (w: 5, s: 3), richtung: .waagerecht))  // Index 5
        autos.append(Car(länge: .zwei, füllFarbe: .systemGreen, randFarbe: .black, positionLinksUnten: (w: 5, s: 5), richtung: .waagerecht))  // Index 6
        autos.append(Car(länge: .drei, füllFarbe: .systemBlue, randFarbe: .black, positionLinksUnten: (w: 1, s: 1), richtung: .senkrecht))    // Index 7
        
        autos.append(Car(länge: .drei, füllFarbe: .systemRed, randFarbe: .black, positionLinksUnten: (w: 3, s: 1), richtung: .senkrecht))    // Index 8
    default:
        return autos
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
        {    var g = [[String]](repeating: [String](repeating: " ", count: 6), count: 6) // 6 x 6 - alle Felder mit " " belegen
            gewonnen = false
            for auto in cars {
                for pos in auto.zellenBelegt {
                    g[pos.w - 1][pos.s - 1] = auto.id
                    if auto.zellenBelegt.first! == (w: 6, s: 4) &&
                        auto.füllFarbe == .red &&
                        auto.länge == .zwei
                    {
                        gewonnen = true
                    }
                }
            }
            return g
        }
    }
    
    func bilderZuordnen () {
        var used = Set<String>()
        for c in 0...cars.count - 1 {
            for b in bildContainer {
                if b.value.Inhalt == .voll &&
                    cars[c].orientierung == b.value.Orientierung &&
                    cars[c].länge == b.value.Länge &&
                    used.contains(b.key) == false
                {
                    cars[c].image = NSImage(imageLiteralResourceName: b.key)
                    used.insert(b.key)
                    
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



