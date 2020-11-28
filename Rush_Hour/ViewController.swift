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
    
    
//    override func mouseUp(with event: NSEvent) {
//        let locationInView = myView.convert(event.locationInWindow, from: nil)
//        let x = locationInView.x
//        let y = locationInView.y
//        var reAngeklickt = NSRect()
//        
//        for w in 1...6 {
//            for s in 1...6 {
//                if MyView.kleineQuadrate[w][s].contains(CGPoint(x: x, y: y)) {
//                    reAngeklickt = MyView.kleineQuadrate[w][s]
//                    print("angeklickt: w: \(w) - s: \(s) - \(reAngeklickt)")
//                    print(reAngeklickt)
//                    print("Grid: \(Spiel.grid)")
//                    
//                    if Spiel.grid[w - 1][s - 1] != " " {
//                        for i in 0...5  {
//                            if Spiel.cars[i].id == Spiel.grid[w - 1][s - 1] {
//                                Spiel.cars[i].randFarbe = .red
//                                myView.setNeedsDisplay(MyView.dörtiRekt)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
}


