//
//  MyView2.swift
//  Rush_Hour
//
//  Created by UT on 12.12.20.
//

import Cocoa

class MyView2: NSView {

    var aufgabeBild = " "
    var rechtsPfeilRect = NSRect()
    var linksPfeilRect = NSRect()
    var zurückRect = NSRect()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
        if aufgabeBild != " "
        {
            let w = dirtyRect.width
            let h = dirtyRect.height
            
            let hinterGrundRe = NSRect(x: 0, y: 0, width: w, height: h)
            let hinterGrunRePfad = NSBezierPath(rect: hinterGrundRe)
            NSColor.brown.setFill()
            hinterGrunRePfad.fill()
            
            let bildSeitenLänge = min(w, h) / 1.2
            let x_bildRe = (w - bildSeitenLänge) / 2
            let y_bildRe = (h - bildSeitenLänge) / 2
            let bildRe = NSRect(x: x_bildRe, y: y_bildRe, width: bildSeitenLänge, height: bildSeitenLänge)
            let bild = NSImage(imageLiteralResourceName: aufgabeBild)
            bild.draw(in: bildRe)
            
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
            
            let zurückWidth = linksPfeilSeitenLänge
            let zurückheight = zurückWidth / 3.1
            let x_zurück: CGFloat = 0
            let y_zurück = h - zurückheight
            zurückRect = NSRect(x: x_zurück, y: y_zurück, width: zurückWidth, height: zurückheight)
            let zurückBild = NSImage(imageLiteralResourceName: "zurück")
            zurückBild.draw(in: zurückRect)
            
            
        }

    }
    
}
