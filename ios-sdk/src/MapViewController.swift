//
//  MapViewController.swift
//  ios-sdk
//
//  Created by Matt Smollinger on 11/21/16.
//  Copyright © 2016 Mapzen. All rights reserved.
//


import UIKit
import TangramMap
import CoreLocation

public class MapViewController: TGMapViewController, LocationManagerDelegate {

    var currentLocationGem: TGMapMarkerId?
    var lastSetPoint: TGGeoPoint?
    var shouldShowCurrentLocation = false

    //! Returns whether or not the map was centered on the device's current location
    public func centerOnCurrentLocation(zoomLevel: Float, animationDuration: Float) -> Bool {
        guard let marker = currentLocationGem else { return false }
        guard let point = lastSetPoint else { return false }
        if marker == 0 { return false } // Invalid Marker
        animateToPosition(point, withDuration: animationDuration)
        animateToZoomLevel(zoomLevel, withDuration: animationDuration)
        return true
    }

    //! Returns whether or not current location was shown
    public func showCurrentLocation(shouldShow: Bool) -> Bool {
        shouldShowCurrentLocation = shouldShow
        guard let marker = currentLocationGem else {
            let marker = markerAdd()
            if marker == 0 { return false } // Didn't initialize correctly.
            currentLocationGem = marker;
            LocationManager.sharedManager.requestWhenInUseAuthorization()
            //TODO: Update once scene updates are properly synchronous - { style: ux-location-gem-overlay, interactive: true, sprite: ux-current-location, size: 36px, collide: false }
            markerSetStyling(marker, styling: "{ style: 'points', color: 'white', size: [25px, 25px], order:500, collide: false }")
            //Set visibility to false since we have to wait until we have an accurate location
            markerSetVisible(marker, visible: false)
            return true
        }
        markerSetVisible(marker, visible: shouldShowCurrentLocation)
        return true
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedManager.delegate = self
    }

    //MARK: - LocationManagerDelegate

    public func locationDidUpdate(location: CLLocation) {
        guard let marker = currentLocationGem else {
            return
        }
        lastSetPoint = TGGeoPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        markerSetPoint(marker, coordinates: TGGeoPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude))
        if (shouldShowCurrentLocation) {
            markerSetVisible(marker, visible: true)
        }
    }

    public func authorizationDidSucceed() {
        LocationManager.sharedManager.startUpdatingLocation()
    }

    public func authorizationDenied() {
        failedLocationAuthorization()
    }

    public func authorizationRestricted() {
        //For our uses, this is effectively the same handling as denied location authorization
        failedLocationAuthorization()
    }

    func failedLocationAuthorization() {
        shouldShowCurrentLocation = false
        guard let marker = currentLocationGem else { return }
        markerRemove(marker)
        return
    }
}
