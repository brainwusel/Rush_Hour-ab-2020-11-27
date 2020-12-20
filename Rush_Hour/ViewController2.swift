//
//  ViewController2.swift
//  Rush_Hour
//
//  Created by UT on 12.12.20.
//

import Cocoa

class ViewController2: NSViewController
{
    var data: Int?
    var aufgabeAusgewählt = 0
    {
        willSet (newValue)
        {
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "AufgabeAktualisieren"),
                object: nil)
            aufgabeBildAktualisieren(aufgabe: newValue)
            print("willSet newValue \(newValue)")
        }
    }
    
    var viewControllerBasis: ViewController?
    
    @IBOutlet var myView2: MyView2!
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        viewControllerBasis = segue.destinationController as? ViewController
        viewControllerBasis!.viewContr2 = self
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear()
    {
        aufgabeAusgewählt = data ?? 1
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
    }
}
