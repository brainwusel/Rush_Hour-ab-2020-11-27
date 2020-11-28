//
//  ViewController.swift
//  Rush_Hour
//
//  Created by UT on 19.11.20.
//

import Cocoa

class ViewController: NSViewController {
    
    var myView = MyView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    override func mouseDown(with event: NSEvent) {
        let locationInView = myView.convert(event.locationInWindow, from: nil)
        let x = locationInView.x
        let y = locationInView.y
        var reAngeklickt = NSRect()
        var kQ = NSRect()
        print("klick: locationInWiev: x = \(x) - y = \(y)")
        print(myView.kleineQuadrate)
//        myView.kleineQuadrateReset()
        for w in 1 ... 6 {
            for s in 1 ... 6 {
                kQ = myView.erzeugeKleinesQuadrat(waagerecht: w, senkrecht: s, farbe: .lightGray, zeichnen: false, myView.dörtiRekt)
                myView.kleineQuadrate[w][s] = kQ
                print("w: \(w) - s: \(s) - \(kQ.minX) \(kQ.minY) \(kQ.maxX) \(kQ.maxY)")
            }
            for w in 1...5 {
                for s in 1...5 {
                    if myView.kleineQuadrate[w][s].contains(CGPoint(x: x, y: y)) {
                        reAngeklickt = myView.kleineQuadrate[w][s]
                        print("angeklickt: w: \(w) - s: \(s) - \(reAngeklickt)")
                        print(reAngeklickt)
                    }
                }
            }
            //        CHECK FÜR ANKLICKEN
            //        var p = NSBezierPath()
            //        p.appendRect(reAngeklickt)
            //        NSColor.white.setFill()
            //        p.fill()
            //        myView.needsDisplay = true
            
            
        }
        
    }
    
}
