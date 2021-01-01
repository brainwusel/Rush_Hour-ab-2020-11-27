//
//  MyView3Rechts.swift
//  Rush_Hour
//
//  Created by UT on 31.12.20.
//

import Cocoa

class MyView3Rechts: NSView {
    
    var paths = [NSBezierPath]()
    
    var bild = NSImage(imageLiteralResourceName: "w20")

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        
        let rahmen = NSRect(x: dirtyRect.minX - 10, y: dirtyRect.minY - 10, width: dirtyRect.width + 20, height: dirtyRect.height + 20)
        NSColor.white.setFill()
        rahmen.fill()
        
        bild.draw(in: dirtyRect)

        
        NSColor.red.setStroke()
        
        for p in paths {
            p.lineWidth = 10
            p.stroke()
        }

        // Drawing code here.
    }
    
}
