//
//  ViewController.swift
//  Rush_Hour
//
//  Created by UT on 19.11.20.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
    
    var spiel = Spiel(Aufgabe: 0)
    var aktuelleAutoID = " "
    var aktuelleAufgabe = 0
    var bewegungsRichtung: Richtung = .unbeweglich {
        didSet (newValue) {
            spiel.move(autoID: aktuelleAutoID, wohin: newValue)
            myView.gewonnen = spiel.gewonnen
            myView.cars = spiel.cars
        }
    }
    
    @IBOutlet weak var myView: MyView!
    @IBOutlet weak var v_onVorne: NSButton!
    @IBAction func vonVorne (_ sender: NSButton) {
        spiel = Spiel(Aufgabe: aktuelleAufgabe)
        myView.gewonnen = spiel.gewonnen
        myView.cars = spiel.cars
    }
    @IBOutlet weak var a_ufgabeNummer: NSTextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        myView.cars = spiel.cars
        a_ufgabeNummer.delegate = self
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        
        let locationInView = myView.convert(event.locationInWindow, from: nil)
        let punkt = CGPoint(x: locationInView.x, y: locationInView.y)
        
        for i in 0...spiel.cars.count - 1 {
            spiel.cars[i].randFarbe = .black
            if spiel.cars[i].rechtEck.contains(punkt) {
                aktuelleAutoID = spiel.cars[i].id
            }
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        
        let dx = event.deltaX
        let dy = event.deltaY
        
        if dx >= 0 && dy >= 0 && dx > dy {
            bewegungsRichtung = .rechts
        }
        if dx >= 0 && dy >= 0 && dy > dx {
            bewegungsRichtung = .runter
        }
        if dx < 0 && abs(dx) > abs(dy) {
            bewegungsRichtung = .links
        }
        if dy < 0 && abs(dx) < abs(dy) {
            bewegungsRichtung = .rauf
        }
    }
    
    func control(_ control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        if control == a_ufgabeNummer {
            let s = a_ufgabeNummer.stringValue
            if var nr = Int(s) {
                nr = max(0, min(1, nr))
                aktuelleAufgabe = nr
                spiel = Spiel(Aufgabe: aktuelleAufgabe)
                myView.cars = spiel.cars
                myView.gewonnen = spiel.gewonnen
            }
            
        }
        return true
    }
    
}


