//
//  ViewController3.swift
//  Rush_Hour
//
//  Created by UT on 30.12.20.
//

import Cocoa

extension CGImage {
    public var nsImage: NSImage? {
        let size = CGSize(width: self.width, height: self.height)
        return NSImage(cgImage: self, size: size)
    }
}

class ViewController3: NSViewController {

    
    var bildAnalysieren = NSImage(imageLiteralResourceName: "Aufgabe2")
    
    var bildZeigen = NSImage(imageLiteralResourceName: "w20") {
        didSet {
            myView3Rechts.bild = self.bildZeigen
            myView3Rechts.display()
        }
    }
    
    var pfade = [NSBezierPath]() {
        didSet {
            myView3Rechts.paths = pfade
            myView3Rechts.display()
        }
    }
    
    var rectDetect: RectDetect!
  
    
    @IBOutlet weak var myView3: MyView3!
    
    @IBOutlet weak var myView3Links: NSImageView!
    
    @IBOutlet weak var myView3Rechts: MyView3Rechts!
    
    
    
    @IBAction func rechteckErkennen(_ sender: NSButton) {
        
        let bildNSImage = rectDetect.pic.nsImage
        print("bildNSImage: \(String(describing: bildNSImage))")
        bildZeigen = bildNSImage!
        
    
        let autoRe = rectDetect.erkannteRekts
        
        print("autoRe \(autoRe)")
        
        pfade.removeAll()
        
        for aR in autoRe {
            let reSkaliert = NSRect(
                x: aR.minX * myView3Rechts.frame.width,
                y: aR.minY * myView3Rechts.frame.height,
                width: aR.width * myView3Rechts.frame.width,
                height: aR.height * myView3Rechts.frame.height)
            pfade.append(NSBezierPath(rect: reSkaliert))
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        myView3Links.image = bildAnalysieren
        rectDetect = RectDetect(bild: bildAnalysieren)
        
    }
    
    override func viewDidAppear() {
//        let re = NSRect(x: 5, y: 5, width: myView3Rechts.frame.width - 10, height: myView3Rechts.frame.height - 10)
//        pfade.append(NSBezierPath(rect: re))
    }
    
    
    
}
