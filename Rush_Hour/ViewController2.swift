//
//  ViewController2.swift
//  Rush_Hour
//
//  Created by UT on 12.12.20.
//

import Cocoa

class ViewController2: NSViewController
{
    let aufgabenTotal = 2                   // Provisorium
    
    @IBOutlet var myView2: MyView2!
    @IBOutlet weak var aufgabeAusgewähltLabel: NSTextField!
    var data: Int?
    
    var aufgabeAusgewählt = 1
    {
        didSet
        {
            myView2.aufgabeBild = "Aufgabe" + String(self.aufgabeAusgewählt)
            myView2.display()
            aufgabeAusgewähltLabel.stringValue = String(self.aufgabeAusgewählt)
            
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
        aufgabeAusgewähltLabel.stringValue = String(aufgabeAusgewählt)
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
            aufgabeAusgewählt = min(aufgabenTotal, aufgabeAusgewählt + 1)
        }
    }
}
