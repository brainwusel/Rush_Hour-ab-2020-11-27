//
//  ViewController2.swift
//  Rush_Hour
//
//  Created by UT on 12.12.20.
//

import Cocoa

class ViewController2: NSViewController {

    var data: Int?
    var aufgabeAusgewählt = 0 {
        willSet (newValue)
        {
            print("newValue VC2.aufgabeAusgewählt \(newValue)")
            NotificationCenter.default.post(
                name: Notification.Name(rawValue: "AufgabeAktualisieren"),
                object: nil)
            aufgabeBildAktualisieren(aufgabe: newValue)
        }
    }
    
    var viewControllerBasis: ViewController?
    
    @IBOutlet var myview2: MyView2!
    
    
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let viewControllerBasis = segue.destinationController as? ViewController
        {
            viewControllerBasis.viewContr2 = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
      
    }
    
    override func viewWillAppear() {
        aufgabeAusgewählt = data ?? 1
    }
    
    func aufgabeBildAktualisieren (aufgabe nr: Int) {
        switch nr {
        case 1:
            myview2.aufgabeBild = "Aufgabe1"
        case 2:
            myview2.aufgabeBild = "Aufgabe2"
        default:
            return
        }
        myview2.display()
    }
}
