//
//  RechteckErkennung.swift
//  Rush_Hour
//
//  Created by UT on 30.12.20.
//

import Foundation
import Vision
import Cocoa

extension NSImage {
    public var cgImage: CGImage? {
        guard let imageData = self.tiffRepresentation else { return nil }
        guard let sourceData = CGImageSourceCreateWithData(imageData as CFData, nil) else { return nil }
        return CGImageSourceCreateImageAtIndex(sourceData, 0, nil)
    }
}

class RectDetect
{
    var bild: NSImage
    init (bild: NSImage) {
        self.bild = bild
    }
    
    var pic: CGImage {
        return bild.cgImage!
    }
    
    var erkannteRekts: [NSRect] {
        return erkenneRechtecke(picture: pic)
    }
    
    var optionMaximumObservations: Int = 0
    var optionMinimumAspectRatio: Float = 0.2
    var optionMaxiumAspectRatio: Float = 0.48
    var optionMinimumSize: Float = 0.1
    var optionQuadratureTolerance: Float = 10
    var optionMinimumConfidence: Float = 0.5
    
    func erkenneRechtecke (picture: CGImage) -> [NSRect]
    {
        var rechtecke = [NSRect]()
        
        let requestHandler = VNImageRequestHandler(cgImage: pic)
        let request = VNDetectRectanglesRequest { request, error in
            completedVisionRequest(request, error: error)
        }
        
        // perform additional request configuration
        request.usesCPUOnly = false //allow Vision to utilize the GPU
        
        request.maximumObservations = optionMaximumObservations
        request.minimumConfidence = optionMinimumConfidence
        request.maximumAspectRatio = optionMaxiumAspectRatio
        request.minimumAspectRatio = optionMinimumAspectRatio
        request.minimumSize = optionMinimumSize
        request.quadratureTolerance = optionQuadratureTolerance
        request.minimumConfidence = optionMinimumConfidence
        
//        DispatchQueue.global().async {
            do {
                try requestHandler.perform([request])
            } catch {
                print("Error: Rectangle detection failed - vision request failed.")
            }
//        }
        
        func completedVisionRequest(_ request: VNRequest?, error: Error?) {
            // Only proceed if a rectangular image was detected.
            guard let rectangles = request?.results as? [VNRectangleObservation] else {
                guard let error = error else { return }
                print("Error: Rectangle detection failed - Vision request returned an error. \(error.localizedDescription)")
                return
            }
            // do stuff with your rectangles
            
            for rectangle in rectangles {
                rechtecke.append(rectangle.boundingBox)
            }
            
        }
        return rechtecke
    }
}

