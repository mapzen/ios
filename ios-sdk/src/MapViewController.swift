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
    //TODO: This will eventually get refactored out to be whatever the current location is from CoreLocation
    let tempPoint = TGGeoPoint(longitude: -122.44880676269531, latitude: 37.76155490343394)

    //! Returns whether or not the map was centered on the device's current location
    public func centerOnCurrentLocation() -> Bool {
        guard let marker = currentLocationGem else { return false }
        if marker == 0 { return false } // Invalid Marker
        animateToPosition(tempPoint, withDuration: 2.0)
        animateToZoomLevel(15, withDuration: 2.0)
        return true
    }

    //! Returns whether or not current location was shown
    public func showCurrentLocation(shouldShow: Bool) -> Bool {
        if (shouldShow){
            guard let marker = currentLocationGem else {
                let marker = markerAdd()
                if marker == 0 { return false } // Didn't initialize correctly.
                currentLocationGem = marker;
                markerSetPoint(marker, coordinates: tempPoint)
                //TODO: Update once scene updates are properly synchronous - { style: ux-location-gem-overlay, interactive: true, sprite: ux-current-location, size: 36px, collide: false }
                markerSetStyling(marker, styling: "{ style: 'points', color: 'white', size: [25px, 25px], order:500, collide: false }")
                return true
            }
            markerSetVisible(marker, visible: true)
        } else {
            guard let marker = currentLocationGem else {
                return false
            }
            markerSetVisible(marker, visible: false)
        }
        return true
    }
}
