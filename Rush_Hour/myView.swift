//
//  myView.swift
//  Rush_Hour
//
//  Created by UT on 24.11.20.
//

import Cocoa

class MyView: NSView {
    
    var dörtiRekt = NSRect()
    var kleineQuadrate = [[NSRect]]()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        dörtiRekt = dirtyRect
        
        let re_Null = NSRect(x: 0, y: 0, width: 0, height: 0)
        kleineQuadrate = [[re_Null, re_Null, re_Null, re_Null, re_Null, re_Null, re_Null],
                          [re_Null, re_Null, re_Null, re_Null, re_Null, re_Null, re_Null],
                          [re_Null, re_Null, re_Null, re_Null, re_Null, re_Null, re_Null],
                          [re_Null, re_Null, re_Null, re_Null, re_Null, re_Null, re_Null],
                          [re_Null, re_Null, re_Null, re_Null, re_Null, re_Null, re_Null],
                          [re_Null, re_Null, re_Null, re_Null, re_Null, re_Null, re_Null],
                          [re_Null, re_Null, re_Null, re_Null, re_Null, re_Null, re_Null]]
        var kleinesQuadrat = NSRect()
        
        
        // Hintergrund
        let re_HinterGrund = NSRect(x: 0, y: 0, width: dirtyRect.width, height: dirtyRect.height)
        let re_HinterGrundPath = NSBezierPath()
        re_HinterGrundPath.appendRect(re_HinterGrund)
        NSColor.white.setFill()
        re_HinterGrundPath.fill()
        
        // Basisquadrat
        _ = erzeugeBasisQuadrat(füllFarbe: .white, randFarbe: .black, zeichnen: true, dirtyRect)
        
        // kleine Quadrate -> Grid
        for w in 1 ... 6 {
            for s in 1 ... 6 {
                kleinesQuadrat = erzeugeKleinesQuadrat(waagerecht: w, senkrecht: s, farbe: .lightGray, zeichnen: true, dirtyRect)
                kleineQuadrate[w][s] = kleinesQuadrat
            }
        }
        
        // Autos
        let spiel = Spiel()
        let cars = spiel.cars
        for auto in cars {
            let re_linksUnten = erzeugeKleinesQuadrat(
                waagerecht: (auto.zellenBelegt.first?.w)!,
                senkrecht: (auto.zellenBelegt.first?.s)!,
                farbe: .white,
                zeichnen: false,
                dirtyRect)
            let re_rechtsOben = erzeugeKleinesQuadrat(
                waagerecht: (auto.zellenBelegt.last?.w)!,
                senkrecht: (auto.zellenBelegt.last?.s)!,
                farbe: .white,
                zeichnen: false,
                dirtyRect)
            let autoPath = NSBezierPath()
            autoPath.appendRect(NSRect(
                                    x: re_linksUnten.minX + 10,
                                    y: re_linksUnten.minY + 10,
                                    width: re_rechtsOben.maxX - re_linksUnten.minX - 20,
                                    height: re_rechtsOben.maxY - re_linksUnten.minY - 20))
            let farbe = auto.farbe
            farbe.setFill()
            autoPath.fill()
            NSColor.black.setStroke()
            autoPath.lineWidth = 5
            autoPath.stroke()
        }
        
    }
    
    func erzeugeBasisQuadrat (füllFarbe: NSColor, randFarbe: NSColor, zeichnen: Bool, _ dirtyRect: NSRect) -> NSRect {
        
        let basisQuadratSeitenlänge = min(dirtyRect.height,dirtyRect.width) - 50
        
        let basisQuadrat = NSRect(
            x: (dirtyRect.width - basisQuadratSeitenlänge) / 2,
            y: (dirtyRect.height - basisQuadratSeitenlänge) / 2,
            width: basisQuadratSeitenlänge,
            height: basisQuadratSeitenlänge)
        
        if zeichnen {
            let bQ = NSBezierPath()
            bQ.appendRect(basisQuadrat)
            füllFarbe.set()
            bQ.fill()
            
            randFarbe.set()
            bQ.lineWidth = 10
            bQ.stroke()
        }
        
        // Exit-Rechteck
        
        let exitRechteck = NSRect(
            x: basisQuadrat.maxX - 6,
            y: basisQuadrat.minY + basisQuadrat.height * 2 / 6 ,
            width: 11, height: basisQuadrat.height / 6 + 2)
        let eR = NSBezierPath()
        eR.appendRect(exitRechteck)
        NSColor.white.set()
        eR.fill()
        
        
        return basisQuadrat
      
    }
    
    func erzeugeKleinesQuadrat (waagerecht w: Int, senkrecht s: Int, farbe: NSColor, zeichnen: Bool, _ dirtyRect: NSRect) -> NSRect {
        
        let basisQuadratSeitenlängeInnen = min(dirtyRect.height,dirtyRect.width) - 65
        
        let innenQuadrat = NSRect(
            x: (dirtyRect.width - basisQuadratSeitenlängeInnen) / 2,
            y: (dirtyRect.height - basisQuadratSeitenlängeInnen) / 2,
            width: basisQuadratSeitenlängeInnen,
            height: basisQuadratSeitenlängeInnen)
        
        let kleinesQuadrat = NSRect(
            x: innenQuadrat.minX + (CGFloat(w) - 1) * innenQuadrat.width / 6 + 2,
            y: innenQuadrat.minY + (CGFloat(s) - 1) * innenQuadrat.height / 6 + 2,
            width: innenQuadrat.width / 6 - 4,
            height: innenQuadrat.height / 6 - 4)
        
        if zeichnen {
            let kQ = NSBezierPath()
            kQ.appendRect(kleinesQuadrat)
            farbe.set()
            kQ.fill()
        }
        return kleinesQuadrat
    }
}
