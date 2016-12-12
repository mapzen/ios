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
    public var findMeButton = UIButton(type: UIButtonType.RoundedRect)

    //! Returns whether or not the map was centered on the device's current location
    public func centerOnCurrentLocation(tilt: Float, zoomLevel: Float, animationDuration: Float) -> Bool {
        guard let marker = currentLocationGem else { return false }
        guard let point = lastSetPoint else { return false }
        if marker == 0 { return false } // Invalid Marker
        animateToZoomLevel(zoomLevel, withDuration: animationDuration)
        animateToPosition(point, withDuration: animationDuration)
        animateToTilt(tilt, withDuration: animationDuration)
        return true
    }

    public func showFindMeButon(shouldShow: Bool) -> Bool {
        findMeButton.hidden = !shouldShow
        findMeButton.enabled = shouldShow
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
            markerSetStyling(marker, styling: "{ style: 'ux-location-gem-overlay', color: 'white', size: [25px, 25px], order:500, collide: false }")
            //Set visibility to false since we have to wait until we have an accurate location
            markerSetVisible(marker, visible: false)
            return true
        }
        markerSetVisible(marker, visible: shouldShowCurrentLocation)
        return true
    }

    @objc func defaultFindMeAction() {
        centerOnCurrentLocation(0.0, zoomLevel: 13.0, animationDuration: 1.0)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedManager.delegate = self
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let viewRect = view.bounds
        findMeButton.frame = CGRect(x: viewRect.width - 60.0, y: viewRect.height - 100.0, width: CGFloat(48), height: CGFloat(48))
        findMeButton.addTarget(self, action: #selector(defaultFindMeAction), forControlEvents: .TouchUpInside)
        findMeButton.enabled = false
        findMeButton.hidden = true
        findMeButton.setBackgroundImage(UIImage(named: "ic_find_me_normal"), forState: UIControlState.Normal)
        findMeButton.backgroundColor = UIColor.whiteColor()
        findMeButton.autoresizingMask = [.FlexibleTopMargin, .FlexibleLeftMargin]
        view.addSubview(findMeButton)
        findMeButton.sizeToFit()
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
