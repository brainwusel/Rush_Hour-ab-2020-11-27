//
//  MyView2.swift
//  Rush_Hour
//
//  Created by UT on 12.12.20.
//

import Cocoa

class MyView2: NSView
{
    var spielView2 = Spiel(Aufgabe: 1)
    var cars = [Car]()
    
    var aufgabeNummer = 1
    {
        didSet
        {
            spielView2 = Spiel(Aufgabe: self.aufgabeNummer)
            cars = spielView2.cars
            display()
        }
    }
    
    
    var rechtsPfeilRect = NSRect()
    var linksPfeilRect = NSRect()
    var zurückRect = NSRect()
    
    override func draw(_ dirtyRect: NSRect)
    {
        super.draw(dirtyRect)
        
        // Drawing code here.
        
        
        let w = dirtyRect.width
        let h = dirtyRect.height
        
        let hinterGrundRe = NSRect(x: 0, y: 0, width: w, height: h)
        let hinterGrunRePfad = NSBezierPath(rect: hinterGrundRe)
        NSColor.brown.setFill()
        hinterGrunRePfad.fill()
        
        zeichneAutoGrid(in: dirtyRect)
        
        let bildSeitenLänge = min(w, h) / 1.2
        let x_bildRe = (w - bildSeitenLänge) / 2
        
        let linksPfeilSeitenLänge = bildSeitenLänge / 4
        let x_linksPfeil = (x_bildRe - linksPfeilSeitenLänge) / 2
        let y_linksPfeil = (dirtyRect.height - linksPfeilSeitenLänge) / 2
        let linksPfeilBild = NSImage(imageLiteralResourceName: "Linkspfeil")
        linksPfeilRect = NSRect(x: x_linksPfeil, y: y_linksPfeil, width: linksPfeilSeitenLänge, height: linksPfeilSeitenLänge)
        linksPfeilBild.draw(in: linksPfeilRect)
        
        let rechtsPfeilSeitenLänge = linksPfeilSeitenLänge
        let x_rechtsPfeil = 0.5 * (w + x_bildRe + bildSeitenLänge - rechtsPfeilSeitenLänge)
        let y_rechtsPfeil = y_linksPfeil
        rechtsPfeilRect = NSRect(x: x_rechtsPfeil, y: y_rechtsPfeil, width: rechtsPfeilSeitenLänge, height: rechtsPfeilSeitenLänge)
        let rechtsPfeilBild = NSImage(imageLiteralResourceName: "Rechtspfeil")
        rechtsPfeilBild.draw(in: rechtsPfeilRect)
        
        let faktor: CGFloat = 20
        zurückRect = NSRect(
            x: 10,
            y: dirtyRect.height - 1.4 * dirtyRect.height / faktor,
            width: 3.1 * dirtyRect.height / faktor,
            height: dirtyRect.height / faktor)
        let zurückButtonImage = NSImage(imageLiteralResourceName: "zurück")
        zurückButtonImage.draw(in: zurückRect)
        
    }
    
    func zeichneAutoGrid (in dörtiRekt: NSRect)
    {
        // Basisquadrat
        
        _ = erzeugeBasisQuadrat(füllFarbe: .black, randFarbe: .black, zeichnen: true, dörtiRekt)
        
        // kleine Quadrate -> Grid
        
        for w in 1 ... 6
        {
            for s in 1 ... 6
            {
                _ = erzeugeKleinesQuadrat(waagerecht: w, senkrecht: s, farbe: .lightGray, zeichnen: true, dörtiRekt)
            }
        }
        
        // Autos
        
        if cars.isEmpty
        {
            return
        }
        else
        {
            autosZeichnen(dörtiRekt)
        }
        
    }
    
    func erzeugeBasisQuadrat (füllFarbe: NSColor, randFarbe: NSColor, zeichnen: Bool, _ dirtyRect: NSRect) -> NSRect
    {
        let basisQuadratSeitenlänge = min(dirtyRect.height - 50,dirtyRect.width  - 300)
        
        let basisQuadrat = NSRect(
            x: 0 + (dirtyRect.width - basisQuadratSeitenlänge) / 2,
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
            x: 0 + (dirtyRect.width - basisQuadratSeitenlängeInnen) / 2,
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
        let dR = dirtyRect
        for i in 0...cars.count - 1
        {
            let re_linksUnten = erzeugeKleinesQuadrat(
                waagerecht: (cars[i].zellenBelegt.first?.w)!,
                senkrecht: (cars[i].zellenBelegt.first?.s)!,
                farbe: .white,
                zeichnen: false,
                dR)
            
            let re_rechtsOben = erzeugeKleinesQuadrat(
                waagerecht: (cars[i].zellenBelegt.last?.w)!,
                senkrecht: (cars[i].zellenBelegt.last?.s)!,
                farbe: .white,
                zeichnen: false,
                dR)
            
            var rechtEck = NSRect()
            
            rechtEck = NSRect(
                x: re_linksUnten.minX + 10,
                y: re_linksUnten.minY + 10,
                width: re_rechtsOben.maxX - re_linksUnten.minX - 20,
                height: re_rechtsOben.maxY - re_linksUnten.minY - 20)
            
            
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


