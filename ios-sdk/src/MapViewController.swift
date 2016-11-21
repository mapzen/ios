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

    public var showCurrentLocation: Bool = false {
        didSet {
            if showCurrentLocation == true {
                print("Queuing scene update for current location")
                self.queueSceneUpdate("layers.mz_current_location_gem.data", withValue: "{ type: FeatureCollection, features: { type: Feature, properties: {}, geometry: { type: Point, coordinates: { -122.44880676269531, 37.76155490343394 } } } }")
                self.applySceneUpdates()
                let point = TGGeoPoint(longitude: -122.44880676269531, latitude: 37.76155490343394)
                self.animateToPosition(point, withDuration: 2.0)
                self.animateToZoomLevel(15, withDuration: 2.0)
            } else {
                self.queueSceneUpdate("layers.mz_current_location_gem.data", withValue: "")
                self.applySceneUpdates()
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
