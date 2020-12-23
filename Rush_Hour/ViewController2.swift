//
//  ViewController2.swift
//  Rush_Hour
//
//  Created by UT on 12.12.20.
//

import Cocoa

class ViewController2: NSViewController
{
    
    var viewControllerBasis: ViewController?
    
    @IBOutlet var myView2: MyView2!
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        viewControllerBasis = segue.destinationController as? ViewController
        viewControllerBasis!.viewContr2 = self
    }
    
    var data: Int?
    var aufgabeAusgewählt = 0
    {
        willSet (newValue)
        {
            
            aufgabeBildAktualisieren(aufgabe: newValue)
            print("VC2 aufgabeAusgewählt willSet newValue \(newValue)")
            viewControllerBasis?.aufgabeAktuell = newValue
            
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "AufgabeAktualisieren"),
                object: nil)
    
        
        }
    }
    
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear()
    {
        aufgabeAusgewählt = data ?? 1
//        aufgabeBildAktualisieren(aufgabe: aufgabeAusgewählt)
    }
    
    override func viewWillDisappear() {
        viewControllerBasis?.aufgabeAktuell = aufgabeAusgewählt
    }
    
    func aufgabeBildAktualisieren (aufgabe nr: Int)
    {
        switch nr
        {
        case 1:
            myView2.aufgabeBild = "Aufgabe1"
        case 2:
            myView2.aufgabeBild = "Aufgabe2"
        default:
            return
        }
        myView2.display()
    }
    
    override func mouseDown(with event: NSEvent) {
        let locationInView = myView2.convert(event.locationInWindow, from: nil)
        let punkt = CGPoint(x: locationInView.x, y: locationInView.y)
        
        if myView2.zurückRect.contains(punkt)
        {
            myView2.window?.close()
        }
        
        if myView2.linksPfeilRect.contains(punkt)
        {
            aufgabeAusgewählt = max(1, aufgabeAusgewählt - 1)
        }
        
        if myView2.rechtsPfeilRect.contains(punkt)
        {
            aufgabeAusgewählt = min(2, aufgabeAusgewählt + 1)
        }
    }
}
