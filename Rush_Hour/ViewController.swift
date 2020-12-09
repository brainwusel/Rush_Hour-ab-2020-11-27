//
//  ViewController.swift
//  Rush_Hour
//
//  Created by UT on 19.11.20.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
    
    var spiel = Spiel(Aufgabe: 1)
    var aktuelleAutoID = " "
    var aktuelleAufgabe = 1
    var bewegungsRichtung: Richtung = .unbeweglich {
        didSet (newValue) {
            spiel.move(autoID: aktuelleAutoID, wohin: newValue)
            updateView()
        }
    }
    
    @IBOutlet weak var myView: MyView!
    @IBOutlet weak var v_onVorne: NSButton!
    @IBAction func vonVorne (_ sender: NSButton) {
        spiel.zurückAufAnfang()
        updateView()
    }
    @IBOutlet weak var a_ufgabeNummer: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        a_ufgabeNummer.delegate = self
        updateView()
        
        
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
            if let nr = Int(s) {
                if nr >= 1 && nr <= 2 {
                    print (nr)
                    spiel = Spiel(Aufgabe: nr)
                    updateView()
                }
            }
            
        }
        return true
    }
    
    @objc func updateView () {
        myView.gewonnen = spiel.gewonnen
        myView.cars = spiel.cars
    }
    
}


