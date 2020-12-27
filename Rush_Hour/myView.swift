//
//  myView.swift
//  Rush_Hour
//
//  Created by UT on 24.11.20.
//

import Cocoa

class MyView: NSView {
    
//    let auto1Image = NSImage(imageLiteralResourceName: "Auto1")
    
    var cars = [Car]()
    {
        didSet
        {
            display()
        }
    }
    var gewonnen = false
    var kleineQuadrate = [[NSRect]]()
    var vonVorneRect = NSRect()
    var aufgabenRect = NSRect()
    
    override func draw(_ dirtyRect: NSRect)
    {
        super.draw(dirtyRect)
        
        // Hintergrund
        
        let hinterGrund = NSBezierPath(rect: NSRect(
                                        x: 0,
                                        y: 0,
                                        width: dirtyRect.width,
                                        height: dirtyRect.height))
        if gewonnen
        {
            NSColor.systemGreen.setFill()
        }
        else
        {
            NSColor.brown.setFill()
        }
        hinterGrund.fill()
        
        // Basisquadrat
        
        _ = erzeugeBasisQuadrat(füllFarbe: .black, randFarbe: .black, zeichnen: true, dirtyRect)
        
        // kleine Quadrate -> Grid
        
        for w in 1 ... 6
        {
            for s in 1 ... 6
            {
                _ = erzeugeKleinesQuadrat(waagerecht: w, senkrecht: s, farbe: .lightGray, zeichnen: true, dirtyRect)
            }
        }
        
        // Autos
        if cars.isEmpty
        {
            return
        }
        else
        {
            autosZeichnen(dirtyRect)
        }
        
        // Button Aufgaben
        
        let faktor: CGFloat = 20
        aufgabenRect = NSRect(
            x: 10,
            y: dirtyRect.height - 1.4 * dirtyRect.height / faktor,
            width: 4 * dirtyRect.height / faktor,
            height: dirtyRect.height / faktor)
        let aufgabenButtonImage = NSImage(imageLiteralResourceName: "Aufgaben")
        aufgabenButtonImage.draw(in: aufgabenRect)
        
        // Button von vorne
        
        vonVorneRect = NSRect(
            x: 10,
            y: dirtyRect.height - 3.4 * dirtyRect.height / faktor,
            width: 4 * dirtyRect.height / faktor,
            height: dirtyRect.height / faktor)
        let vonVorneButtonImage = NSImage(imageLiteralResourceName: "vonvorne")
        vonVorneButtonImage.draw(in: vonVorneRect)
    }
    
    func erzeugeBasisQuadrat (füllFarbe: NSColor, randFarbe: NSColor, zeichnen: Bool, _ dirtyRect: NSRect) -> NSRect
    {
        let basisQuadratSeitenlänge = min(dirtyRect.height - 50,dirtyRect.width  - 300)
        
        let basisQuadrat = NSRect(
            x: 50 + (dirtyRect.width - basisQuadratSeitenlänge) / 2,
            y: (dirtyRect.height - basisQuadratSeitenlänge) / 2,
            width: basisQuadratSeitenlänge,
            height: basisQuadratSeitenlänge)
        
        if zeichnen
        {
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
            x: basisQuadrat.maxX - 10,
            y: basisQuadrat.minY + basisQuadrat.height * 3 / 6 + 2,
            width: 15, height: basisQuadrat.height / 6 - 6.5)
        let eR = NSBezierPath()
        eR.appendRect(exitRechteck)
        NSColor.lightGray.set()
        eR.fill()
        
        return basisQuadrat
    }
    
    func erzeugeKleinesQuadrat (waagerecht w: Int, senkrecht s: Int, farbe: NSColor, zeichnen: Bool, _ dirtyRect: NSRect) -> NSRect
    {
        let basisQuadratSeitenlängeInnen = min(dirtyRect.height - 50,dirtyRect.width - 300) - 15
        
        let innenQuadrat = NSRect(
            x: 50 + (dirtyRect.width - basisQuadratSeitenlängeInnen) / 2,
            y: (dirtyRect.height - basisQuadratSeitenlängeInnen) / 2,
            width: basisQuadratSeitenlängeInnen,
            height: basisQuadratSeitenlängeInnen)
        
        let kleinesQuadrat = NSRect(
            x: innenQuadrat.minX + (CGFloat(w) - 1) * innenQuadrat.width / 6 + 2,
            y: innenQuadrat.minY + (CGFloat(s) - 1) * innenQuadrat.height / 6 + 2,
            width: innenQuadrat.width / 6 - 4,
            height: innenQuadrat.height / 6 - 4)
        
        if zeichnen
        {
            let kQ = NSBezierPath()
            kQ.appendRect(kleinesQuadrat)
            farbe.set()
            kQ.fill()
        }
        
        return kleinesQuadrat
    }
    
    
    func autosZeichnen (_ dirtyRect: NSRect)
    {
        let dörtiRekt = dirtyRect
        for i in 0...cars.count - 1
        {
            let re_linksUnten = erzeugeKleinesQuadrat(
                waagerecht: (cars[i].zellenBelegt.first?.w)!,
                senkrecht: (cars[i].zellenBelegt.first?.s)!,
                farbe: .white,
                zeichnen: false,
                dörtiRekt)
            
            let re_rechtsOben = erzeugeKleinesQuadrat(
                waagerecht: (cars[i].zellenBelegt.last?.w)!,
                senkrecht: (cars[i].zellenBelegt.last?.s)!,
                farbe: .white,
                zeichnen: false,
                dörtiRekt)
            
            var rechtEck = NSRect()
            
            if gewonnen && cars[i].länge == .zwei && cars[i].orientierung == .waagerecht
            {
                rechtEck = NSRect(
                    x: re_linksUnten.minX + 10,
                    y: re_linksUnten.minY + 10,
                    width: (re_rechtsOben.maxX - re_linksUnten.minX) * 2 - 20,
                    height: re_rechtsOben.maxY - re_linksUnten.minY - 20)
            }
            else
            {
                rechtEck = NSRect(
                    x: re_linksUnten.minX + 10,
                    y: re_linksUnten.minY + 10,
                    width: re_rechtsOben.maxX - re_linksUnten.minX - 20,
                    height: re_rechtsOben.maxY - re_linksUnten.minY - 20)
            }
            
            cars[i].rechtEck = rechtEck
            
            let autoPath = NSBezierPath()
            autoPath.appendRect(rechtEck)
            if i == 0
            {
                NSColor.red.setFill()
            } else
            {
                NSColor.white.setFill()
            }
            autoPath.fill()
            if let bild = cars[i].image
            {
                bild.draw(in: rechtEck)
            }
        }
    }
}
