//
//  ViewController.swift
//  Rush_Hour
//
//  Created by UT on 19.11.20.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate
{
    var spiel = Spiel(Aufgabe: 1)
    var autoIDAktuell = " "
    var aufgabeAktuell = 1
    {
        willSet (newValue) {
            spiel = Spiel(Aufgabe: newValue)
            aufgabeNummerLabel.stringValue = String(newValue)
            updateView()
        }
    }
    
    var bewegungsRichtung: Richtung = .unbeweglich
    {
        willSet (newValue)
        {
            spiel.move(autoID: autoIDAktuell, wohin: newValue)
            updateView()
        }
    }
    
    weak var viewContr2: ViewController2?
    var win2array = [NSWindowController]()
    @IBOutlet weak var myView: MyView!
    @IBOutlet weak var aufgabeNummerLabel: NSTextField!
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?)
    {
        if let destWindowController = segue.destinationController as? NSWindowController
        {
            if let vc2 = destWindowController.contentViewController as? ViewController2
            {
                viewContr2 = vc2
                viewContr2!.data = aufgabeAktuell
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        updateView()
        
        aufgabeNummerLabel.stringValue = "1"
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.aufgabeAktualisieren),
            name: Notification.Name(rawValue: "AufgabeAktualisieren"),
            object: nil)
        
    }
    
    override var representedObject: Any?
    {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    override func mouseDown(with event: NSEvent)
    {
        let locationInView = myView.convert(event.locationInWindow, from: nil)
        let punkt = CGPoint(x: locationInView.x, y: locationInView.y)
        
        for i in 0...spiel.cars.count - 1 {
            if spiel.cars[i].rechtEck.contains(punkt)
            {
                autoIDAktuell = spiel.cars[i].id
            }
        }
        
        if myView.aufgabenRect.contains(punkt)
        {
            performSegue(withIdentifier: "segueToVC2", sender: myView)
        }
        
        if myView.vonVorneRect.contains(punkt)
        {
            spiel.zurückAufAnfang()
            updateView()
        }
    }
    
    override func mouseDragged(with event: NSEvent)
    {
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
    
    func updateView ()
    {
        myView.gewonnen = spiel.gewonnen
        myView.cars = spiel.cars
    }
    
    @objc func aufgabeAktualisieren ()
    {
        aufgabeAktuell = viewContr2?.aufgabeAusgewählt ?? 1    
    }
}


