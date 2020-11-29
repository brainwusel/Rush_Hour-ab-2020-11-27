//
//  myView.swift
//  Rush_Hour
//
//  Created by UT on 24.11.20.
//

import Cocoa

class MyView: NSView {
    
    var spiel = Spiel()
    var dörtiRekt = NSRect()
    var kleineQuadrate = [[NSRect]]()
    var aktuelleAutoID = " "
    var bewegungsRichtung: Richtung = .unbeweglich {
        didSet (newValue) {
            spiel.move(autoID: aktuelleAutoID, wohin: newValue)
            autosZeichnen()
            display()
        }
    }
    var hintergrundFarbe = NSColor.white
    
    
    
    override func draw(_ dirtyRect: NSRect) {
        
        super.draw(dirtyRect)
        
        dörtiRekt = dirtyRect
        
        // Hintergrund
        
        let re_HinterGrund = NSRect(x: 0, y: 0, width: dirtyRect.width, height: dirtyRect.height)
        let re_HinterGrundPath = NSBezierPath()
        re_HinterGrundPath.appendRect(re_HinterGrund)
        if spiel.gewonnen {
            hintergrundFarbe = .green
        }
        else {
            hintergrundFarbe = .white
        }
        hintergrundFarbe.setFill()
        re_HinterGrundPath.fill()
        
        // Basisquadrat
        
        _ = erzeugeBasisQuadrat(füllFarbe: .white, randFarbe: .black, zeichnen: true, dirtyRect)
        
        // kleine Quadrate -> Grid
        
        for w in 1 ... 6 {
            for s in 1 ... 6 {
                _ = erzeugeKleinesQuadrat(waagerecht: w, senkrecht: s, farbe: .lightGray, zeichnen: true, dirtyRect)
            }
        }
        
        // Autos
        
        autosZeichnen()
        
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
    
    
    func autosZeichnen () {
        for i in 0...7 {
            let re_linksUnten = erzeugeKleinesQuadrat(
                waagerecht: (spiel.cars[i].zellenBelegt.first?.w)!,
                senkrecht: (spiel.cars[i].zellenBelegt.first?.s)!,
                farbe: .white,
                zeichnen: false,
                dörtiRekt)
            
            let re_rechtsOben = erzeugeKleinesQuadrat(
                waagerecht: (spiel.cars[i].zellenBelegt.last?.w)!,
                senkrecht: (spiel.cars[i].zellenBelegt.last?.s)!,
                farbe: .white,
                zeichnen: false,
                dörtiRekt)
            
            var rechtEck = NSRect()
            
            if spiel.gewonnen &&
                spiel.cars[i].länge == .zwei &&
                spiel.cars[i].füllFarbe == .red {
                rechtEck = NSRect(
                    x: re_linksUnten.minX + 10,
                    y: re_linksUnten.minY + 10,
                    width: (re_rechtsOben.maxX - re_linksUnten.minX) * 2 - 20,
                    height: re_rechtsOben.maxY - re_linksUnten.minY - 20)
            } else {
                rechtEck = NSRect(
                    x: re_linksUnten.minX + 10,
                    y: re_linksUnten.minY + 10,
                    width: re_rechtsOben.maxX - re_linksUnten.minX - 20,
                    height: re_rechtsOben.maxY - re_linksUnten.minY - 20)
            }
            
            spiel.cars[i].rechtEck = rechtEck
            
            let autoPath = NSBezierPath()
            autoPath.appendRect(rechtEck)
            let füllFarbe = spiel.cars[i].füllFarbe
            füllFarbe.setFill()
            autoPath.fill()
            let randFarbe = spiel.cars[i].randFarbe
            randFarbe.setStroke()
            autoPath.lineWidth = 5
            autoPath.stroke()
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        
        let locationInView = self.convert(event.locationInWindow, from: nil)
        let punkt = CGPoint(x: locationInView.x, y: locationInView.y)
        
        for i in 0...7 {
            spiel.cars[i].randFarbe = .black
            if spiel.cars[i].rechtEck.contains(punkt) {
                spiel.cars[i].randFarbe = .white
                self.setNeedsDisplay(dörtiRekt)
                aktuelleAutoID = spiel.cars[i].id
            }
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        let dx = event.deltaX
        let dy = event.deltaY
        
        if dx >= 0 && dy >= 0 && dx > dy {
            bewegungsRichtung = .rechts
        }
        if dx >= 0 && dy >= 0 && dy > dx {
            bewegungsRichtung = .runter
        }
        if dx < 0 && abs(dx) > abs(dy) {
            bewegungsRichtung = .links
        }
        if dy < 0 && abs(dx) < abs(dy) {
            bewegungsRichtung = .rauf
        }
    }
}
