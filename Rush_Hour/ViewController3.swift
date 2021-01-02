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

    
    var bildAnalysieren = NSImage(imageLiteralResourceName: "testimportsw")
    
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
    
    
    
    
    @IBOutlet weak var maxObserv: NSTextField!
    
    @IBOutlet weak var minAspRatio: NSTextField!
    
    @IBOutlet weak var maxAspRatio: NSTextField!
    
    @IBOutlet weak var minSize: NSTextField!
    
    @IBOutlet weak var quadratToler: NSTextField!
    
    @IBOutlet weak var minConfid: NSTextField!
    
    
    
    @IBAction func rechteckErkennen(_ sender: NSButton) {
        
        let bildNSImage = rectDetect.pic.nsImage
        print("bildNSImage: \(String(describing: bildNSImage))")
        bildZeigen = bildNSImage!
        
        rectDetect.optionMaximumObservations = Int(maxObserv.intValue)
        rectDetect.optionMinimumAspectRatio = minAspRatio.floatValue
        rectDetect.optionMaxiumAspectRatio = maxAspRatio.floatValue
        rectDetect.optionMinimumSize = minSize.floatValue
        rectDetect.optionQuadratureTolerance = quadratToler.floatValue
        rectDetect.optionMinimumConfidence = minConfid.floatValue
    
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
        
        maxObserv.intValue = 0
        minAspRatio.floatValue = 0.1
        maxAspRatio.floatValue = 0.5
        minSize.floatValue = 0.1
        quadratToler.floatValue = 30
        minConfid.floatValue = 0.5
        
        
    }
    
    override func viewDidAppear() {
//        let re = NSRect(x: 5, y: 5, width: myView3Rechts.frame.width - 10, height: myView3Rechts.frame.height - 10)
//        pfade.append(NSBezierPath(rect: re))
    }
    
    
    
}
