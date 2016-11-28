//
//  MapViewController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 11/21/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//


import UIKit
import TangramMap

public class MapViewController: TGMapViewController {

    var currentLocationGem: TGMapMarkerId?

    public var showCurrentLocation: Bool = false {
        didSet {
            if showCurrentLocation {
                let point = TGGeoPoint(longitude: -122.44880676269531, latitude: 37.76155490343394)
                guard let marker = currentLocationGem else {
                    let marker = markerAdd()
                    if marker == 0 { return } // Didn't initialize correctly.
                    currentLocationGem = marker;
                    markerSetPoint(marker, coordinates: point)
                    //TODO: Update once scene updates are properly synchronous - { style: ux-location-gem-overlay, interactive: true, sprite: ux-current-location, size: 36px, collide: false }
                    markerSetStyling(marker, styling: "{ style: 'points', color: 'white', size: [25px, 25px], order:500, collide: false }")
                    animateToPosition(point, withDuration: 2.0)
                    animateToZoomLevel(15, withDuration: 2.0)
                    currentLocationGem = marker
                    return
                }
                markerSetVisible(marker, visible: true)
            } else {
                guard let marker = currentLocationGem else {
                    return;
                }
                markerSetVisible(marker, visible: false)
            }
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
