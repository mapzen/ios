//
//  TestAnnotationTarget.swift
//  ios-sdk
//
//  Created by Sarah Lensing on 3/9/17.
//  Copyright © 2017 Mapzen. All rights reserved.
//

import Foundation
import TangramMap
@testable import MapzenSDK

class AnnotationTestTarget : UIResponder, MapMarkerSelectDelegate {

  @objc var annotationClicked = false
  @objc var annotationClickedNoParam = false
  @objc var markerSelected = false

  @objc func annotationClicked(annotation : PeliasMapkitAnnotation) {
    annotationClicked = true
  }

  @objc func annotationClickedNoParams() {
    annotationClickedNoParam = true
  }

  @objc func mapController(_ controller: MZMapViewController, didSelectMarker marker: GenericMarker, atScreenPosition position: CGPoint) {
    markerSelected = true
  }
}
