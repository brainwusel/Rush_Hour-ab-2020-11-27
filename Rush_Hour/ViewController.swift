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
        let x = event.locationInWindow.x
        let y = event.locationInWindow.y
        var reAngeklickt = NSRect()
        var kQ = NSRect()
        print("klick: x = \(x) - x = \(y)")
        myView.kleineQuadrateReset()
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
                    print("w: \(w) - s: \(s)")
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
