//
//  Model.swift
//  Rush_Hour
//
//  Created by UT on 20.11.20.
//

import Foundation
import Cocoa

// 6 x 6
// 4 Dreier + 4 Zweier
// von LINKS nach RECHTS waagerecht w =  1 2 3 4 5 6
// von UNTEN nach OBEN nach senkrecht s = 1 2 3 4 5 6
// Ausgang rechts neben w = 6 / s = 3
// CAVE im zweidimensionalen Array SPIEL.GRID, welches die einzelnen Zellen das 6 x 6 Spielfeldes repräsentiert, sind die Indizes der einzelnen Felder um den Wert 1 KLEINER (0 ... 5, da Array) als die Positionsbezeichnung in der KLasse CAR (w bzw. s 1...6)

// Länge des Autos
enum Länge: Int {
    case zwei = 2
    case drei = 3
}

// Orientierung des Autos auf dem Spielfeld
enum Orientierung: String {
    case waagerecht = "w"
    case senkrecht = "s"
}

// Bewegungsrichtung: Optionen für Autos bzw. Input über Maus / Taste
enum Richtung {
    case rechts
    case links
    case rauf
    case runter
    case unbeweglich
}

// einzelnes Auto - identifiziert durch Länge und Farbe in der computet prop. ID als String. Aus der Aufgabenstellung ergeben sich die Eigenschaften POSITIONLINKSOBEN und ORIENTIERUNG. Die Eigenschaft BEWEGUNGSOPTIONEN zeigt als Array von Richtungen an, wohin ein Auto bewegt werden könnte; sie wird zunächst mit einem Element .UNBEWEGLICH initialisiert und später durch die Methode SPIEL.BEWEGUNGSOPTIONENUPDATE aus den Positionsdaten aller Autos berechnet. Die Eigenschaft ZELLENBELEGT zeigt an, welche Zellen gerade von einem Auto im Grid belegt werden und wird berechnet aus der POSITIONLINKSOBEN, der LÄNGE und der ORIENTIERUNG des Autos; in der get-Funktion sind KEINE Überprüfungen der waagerechten oder senkrechten Limits enthalten - diese Aufgabe sollte vollständig von der Methode SPIEL.BEWEGUNSOPTIONENUPDATE übernommen werden
class Car {
    var länge: Länge
    var füllFarbe: NSColor
    var randFarbe: NSColor
    var orientierung: Orientierung
    var positionLinksUnten: (w: Int, s: Int)
    var bewegungsOptionen: [Richtung]
    
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
            zB.append(positionLinksUnten)
            
            if länge == .zwei && orientierung == .waagerecht {
                zB.append((w: positionLinksUnten.w + 1, s: positionLinksUnten.s))
            }
            if länge == .zwei && orientierung == .senkrecht {
                zB.append((w: positionLinksUnten.w, s: positionLinksUnten.s + 1))
            }
            if länge == .drei && orientierung == .waagerecht {
                zB.append((w: positionLinksUnten.w + 1, s: positionLinksUnten.s))
                zB.append((w: positionLinksUnten.w + 2, s: positionLinksUnten.s))
            }
            if länge == .drei && orientierung == .senkrecht {
                zB.append((w: positionLinksUnten.w, s: positionLinksUnten.s + 1))
                zB.append((w: positionLinksUnten.w, s: positionLinksUnten.s + 2))
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

//  Aufgabe 1 aus ScreenShot - eine Logik für die Auswahl verschiedender Aufgaben fehlt noch
//  standardisierte Reihenfolge der Autos im Auto-Array: "Zweier" rot gelb grün blau "Dreier" rot gelb grün blau, "Zweier" rot ist das Exit-Auto
func initAutos () -> [Car] {
    var autos = [Car]()
    
    autos.append(Car(länge: .zwei, füllFarbe: .red, randFarbe: .black, positionLinksUnten: (w: 2, s: 3), richtung: .waagerecht))    // Index 0 = Exit-Auto
    autos.append(Car(länge: .zwei, füllFarbe: .yellow, randFarbe: .black, positionLinksUnten: (w: 1, s: 1), richtung: .waagerecht)) // Index 1
    autos.append(Car(länge: .zwei, füllFarbe: .green, randFarbe: .black, positionLinksUnten: (w: 5, s: 5), richtung: .waagerecht))  // Index 2
    autos.append(Car(länge: .zwei, füllFarbe: .blue, randFarbe: .black, positionLinksUnten: (w: 1, s: 5), richtung: .senkrecht))    // Index 3
    
    autos.append(Car(länge: .drei, füllFarbe: .orange, randFarbe: .black, positionLinksUnten: (w: 1, s: 2), richtung: .senkrecht))     // Index 4
    autos.append(Car(länge: .drei, füllFarbe: .systemYellow, randFarbe: .black, positionLinksUnten: (w: 6, s: 1), richtung: .senkrecht))  // Index 5
    autos.append(Car(länge: .drei, füllFarbe: .systemGreen, randFarbe: .black, positionLinksUnten: (w: 3, s: 6), richtung: .waagerecht))  // Index 6
    autos.append(Car(länge: .drei, füllFarbe: .systemBlue, randFarbe: .black, positionLinksUnten: (w: 4, s: 2), richtung: .senkrecht))    // Index 7
    
    return autos
}


class Spiel {
    
    //  alle Autos aus dem Rush Hour ScreenShot = Aufgabe1
    static var cars: [Car] = initAutos()
    
    //  Belegung der einzelnen Zellen durch Auto-ID (String aus LÄNGE und FARBE), falls leer: " ". Die Funktion überprüft NICHT, ob die Autos korrekt platziert wurden; das sollte vollständig durch die Methode BEWEGUNGSOPTIONENUPDATE sichergestellt werden. Es setzt auch voraus, dass die Aufgabenstellung korrekt formuliert ist.
    static var grid: [[String]] {
        get {
            var g = [[String]](repeating: [String](repeating: " ", count: 6), count: 6) // 6 x 6 - alle Felder mit " " belegen
            for auto in cars {
                for pos in auto.zellenBelegt {
                    g[pos.w - 1][pos.s - 1] = auto.id
                }
            }
            return g
        }
    }
    
    //    verschiebe ein bestimmtes Auto um eine Zelle, Identifizierung des Autos über den String ID
    static func move (autoID: String, wohin: Richtung) {      // AUTOID: und WOHIN: werden von Maus- bzw. Tastatursignalen bestimmt
        bewegungsOptionenUpdate(cars: &cars)
        for auto in cars {
            if auto.id == autoID {
                if auto.bewegungsOptionen.contains(wohin) {
                    switch wohin {
                    case .rechts:
                        auto.positionLinksUnten.w += 1
                    case .links:
                        auto.positionLinksUnten.w -= 1
                    case .rauf:
                        auto.positionLinksUnten.s += 1
                    case .runter:
                        auto.positionLinksUnten.s -= 1
                    default:
                        return
                    }
                }
            }
        }
        //aktualisiert die Eigenschaft ZELLENBELEGT für jedes Autos, aus der sich automatisch das GRID berechnet
        bewegungsOptionenUpdate(cars: &cars)
    }
    
    //    wohin kann welches Auto bewegt werden?
    static func bewegungsOptionenUpdate (cars: inout [Car]) {
        for auto in cars {
            
            let links = auto.zellenBelegt.first?.w
            let rechts = auto.zellenBelegt.last?.w
            let unten = auto.zellenBelegt.first?.s
            let oben = auto.zellenBelegt.last?.s
            
            if auto.orientierung == .waagerecht {
                
                if links! > 1 && grid[links! - 2][unten! - 1] == " " {
                    auto.bewegungsOptionen.append(.links)
                }
                if rechts! < 6 && grid[rechts!][oben! - 1] == " " {
                    auto.bewegungsOptionen.append(.rechts)
                }
                if rechts! == 6 && oben! == 3 {                    // Exit!
                    auto.bewegungsOptionen.append(.rechts)
                }
            }
            
            if auto.orientierung == .senkrecht {
                if unten! > 1 && grid[links! - 1][unten! - 2] == " " {
                    auto.bewegungsOptionen.append(.runter)
                }
                if oben! < 6 && grid[rechts! - 1][oben!] == " " {
                    auto.bewegungsOptionen.append(.rauf)
                }
            }
        }
    }
    
    //    welches Auto belegt eine bestimmte Zelle?
   static func autoAufZelle (waagerecht: Int, senkrecht: Int) -> Car? {       // waagerecht, senkrecht: 1 ... 6
        let identifier = grid[waagerecht - 1][senkrecht - 1]
        var auto: Car? = nil
        for c in cars {
            if c.id == identifier {
                auto = c
            }
        }
        return auto                                                     // gibt NIL aus, wenn Zelle nicht von Auto belegt
    }
}



